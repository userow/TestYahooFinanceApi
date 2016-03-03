//
//  YFQuotesSearchResultsViewController.m
//  TestYahooFinanceApi
//
//  Created by Pavel Wasilenko on 160303
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import "YFQuotesSearchResultsViewController.h"
#import "YFQuote.h"
#import "YFEmptySearchView.h"

@interface YFQuotesSearchResultsViewController ()

@property (nonatomic, strong) YFEmptySearchView * stubView;

@end

@implementation YFQuotesSearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _stubView = [[[NSBundle mainBundle] loadNibNamed:@"YFEmptySearchView" owner:self options:nil] objectAtIndex:0];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    
    self.tableView.tableFooterView = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectZero];
}

- (void) reloadData {
    [self.tableView reloadData];
}

- (void)reloadBackground
{
    if ( self.searchedQuotes.count == 0 && !_searching)
    {
        self.tableView.backgroundView = _stubView;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [self reloadBackground];

    return self.searchedQuotes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (cell == nil) {
        cell = [UITableViewCell new];
    }

    YFQuote * quote = self.searchedQuotes[indexPath.row];
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.attributedText = quote.cellFormatedRepresentation;

    return cell;
}

@end
