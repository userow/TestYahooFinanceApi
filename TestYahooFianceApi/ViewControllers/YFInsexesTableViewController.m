//
//  YFInsexesTableViewController.m
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import "YFInsexesTableViewController.h"

#import "YFQuotesSearchResultsViewController.h"

#import "YFApiCalls.h"
#import "YFQuote.h"

#import <SVProgressHUD.h>
#import <UIView+AutoLayout.h>

@interface YFInsexesTableViewController ()
<UITableViewDelegate,
UISearchBarDelegate,
UISearchResultsUpdating,
UISearchControllerDelegate> {
    __block BOOL isSearching;
    NSString *previousSearchText;
}

@property (strong, nonatomic) __block NSArray *defaultQuotes;

@property (weak, nonatomic) IBOutlet UIView *searchContainerView;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) YFQuotesSearchResultsViewController *resultsTableController;


@end

@implementation YFInsexesTableViewController

#pragma mark - view controller life cucle
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {

}

-(void)viewDidAppear:(BOOL)animated {
    //    [super viewDidDisappear:animated];
    
    [self loadApiData];
    
    [self registerForKeyboardNotifications];

//    self.searchController.searchBar becomeFirstResponder
    self.searchController.active = YES;
    self.searchController.active = NO;
}

-(void)viewDidDisappear:(BOOL)animated {
    //    [super viewDidDisappear:animated];
    
    [self unRegisterFromKeyboardNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupUI];
    
    [self setupSearch];
    
//    self.searchContainerView.backgroundColor = [UIColor redColor];
}

-(void)setupUI
{
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = @"Yahoo IT stock quotes";
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
}


-(void)setupSearch {
    _resultsTableController = [[YFQuotesSearchResultsViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    
//    UIView *header = [UIView new];
//    header.frame = CGRectMake(0, 0, self.view.frame.size.width, 44.0f);
//    header.clipsToBounds = YES;
//    [header addSubview:self.searchController.searchBar];
//    self.table.tableHeaderView = header;
    
    [self.searchContainerView addSubview:self.searchController.searchBar];
    
    self.definesPresentationContext = YES;
//    [self.searchContainerView bringSubviewToFront:self.searchController.searchBar];
//    self.searchController.searchBar.clipsToBounds = YES;
    
//    [self.searchController.searchBar sizeToFit];
//    [self.searchController.searchBar autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    

    
    self.resultsTableController.tableView.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
    // Search Bar Customization
    // Backgroud Color
    self.searchController.searchBar.backgroundColor = [UIColor darkGrayColor];
    
    // Search Bar Cancel Button Color
//    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor drm_darkishPurpleColor]];
    
    // set Search Bar Search icon
//    [self.searchController.searchBar setImage:[UIImage imageNamed:@"SearchBarIcon"]
//                             forSearchBarIcon:UISearchBarIconSearch
//                                        state:UIControlStateNormal];
    
    // set Search Bar texfield corder radius
    UITextField *searchTextField = [self.searchController.searchBar valueForKey:@"_searchField"];
    
    searchTextField.layer.cornerRadius = 14.0f;
    searchTextField.layer.shouldRasterize = YES;
    searchTextField.layer.rasterizationScale = [UIScreen mainScreen].scale;
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.placeholder = @"Search Quotes";
    
    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.alignment                = NSTextAlignmentLeft;
        
        NSAttributedString *attributedString   =
        [NSAttributedString.alloc initWithString:@"Search Quotes"
                                      attributes:
         @{NSParagraphStyleAttributeName:paragraphStyle,
           NSForegroundColorAttributeName:[UIColor grayColor]}];
        
        [searchTextField setAttributedPlaceholder:attributedString];
    }
    
    for (UIView *subview in self.searchController.searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
        
        for (UIView *subsub in [subview subviews]) {
            if ([subsub isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subsub removeFromSuperview];
                break;
            }
        }
    }
    self.definesPresentationContext = YES;
}

#pragma mark - data

- (void) loadApiData {
    [self showWithStatusSuccess];
    
    __weak typeof(self) weakSelf = self;
    [[YFApiCalls sharedCalls] getDefaultQuotesSuccess:^(id object) {
        __strong typeof(self) strongSelf = weakSelf;

        strongSelf.defaultQuotes = (NSArray *)object;
        [strongSelf reloadData];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void) reloadData {
    [self.table reloadData];
}

#pragma mark - Keyboard

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unRegisterFromKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info  = notification.userInfo;
    NSValue *kbFrame    = info[UIKeyboardFrameEndUserInfoKey];
    
    NSTimeInterval animationDuration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame    = [kbFrame CGRectValue];
    CGFloat height          = keyboardFrame.size.height;
    self.bottomConstraint.constant = height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info                  = notification.userInfo;
    NSTimeInterval animationDuration    = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.defaultQuotes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!cell)
        cell = [UITableViewCell new];
    
    YFQuote * q = self.defaultQuotes[indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.attributedText = q.cellFormatedRepresentation;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.resultsTableController.searchedQuotes = nil;
    [self.table reloadData];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self showWithStatusSuccess];
    
    NSString *searchText = [searchController.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (strippedString.length > 0) {
        
        [self getSearchResults:searchText shouldReload:YES];
    } else {
        [SVProgressHUD dismiss];
    }
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    [searchController.searchBar becomeFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
}


- (void)showWithStatusSuccess {
    if (![SVProgressHUD isVisible]) {
        [SVProgressHUD show];
    }
}

- (void)getSearchResults:(NSString*)searchString shouldReload:(BOOL)shouldReload {
    YFQuotesSearchResultsViewController *tableController = (YFQuotesSearchResultsViewController *)self.searchController.searchResultsController;
    
    tableController.searching = NO;
    
#warning !!! Поставить обработку в ApiCalls
//    [self sendSearchResuts:[_controller searchByString:searchString ]];
}

- (void)sendSearchResuts:(NSMutableArray *)searchResults {
    YFQuotesSearchResultsViewController *tableController = (YFQuotesSearchResultsViewController *)self.searchController.searchResultsController;
    tableController.searchedQuotes = searchResults;
    [tableController reloadData];
    [SVProgressHUD dismiss];
    isSearching = NO;
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    //    if (isExiting)
    //        [self.navigationController popViewControllerAnimated:YES];
}

@end
