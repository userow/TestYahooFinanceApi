//
//  YFQuotesSearchResultsViewController.h
//  TestYahooFinanceApi
//
//  Created by Pavel Wasilenko on 160303
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YFQuotesSearchResultsViewController : UITableViewController

@property (nonatomic, strong) NSArray *searchedQuotes;
@property (nonatomic, assign) BOOL searching;

- (void) reloadData;

@end
