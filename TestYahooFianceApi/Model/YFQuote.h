//
//  YFQuote.h
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

@import Foundation;

@class RKObjectMapping;

@interface YFQuote : NSObject

/*
 "list" : {
 "meta" : { "type" : "resource-list", "start" : 0, "count" : 3 },
 "resources" : [
 {
 "resource" : {
 "classname" : "Quote",
 "fields" : {
 "change" : "-2.189995",
 "chg_percent" : "-2.260523",
 "day_high" : "96.500000",
 "day_low" : "94.550003",
 "issuer_name" : "Apple Inc.",
 "issuer_name_lang" : "Apple Inc.",
 "name" : "Apple Inc.",
 "price" : "94.690002",
 "symbol" : "AAPL",
 "ts" : "1456261200",
 "type" : "equity",
 "utctime" : "2016-02-23T21:00:00+0000",
 "volume" : "31924651",
 "year_high" : "134.540000",
 "year_low" : "92.000000"
 }
 }
 } 
 ]
 

"change" : "-2.189995",
"chg_percent" : "-2.260523",
"day_high" : "96.500000",
"day_low" : "94.550003",
"name" : "Apple Inc.",
"price" : "94.690002",
"symbol" : "AAPL",
*/

@property (nonatomic, strong) NSNumber *change;
@property (nonatomic, strong) NSNumber *changePercent;
@property (nonatomic, strong) NSNumber *dayHigh;
@property (nonatomic, strong) NSNumber *dayLow;
@property (nonatomic, strong) NSNumber *price;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *symbol;

@property (nonatomic, strong) NSString *symbolString;

+(instancetype)quoteWithSymbolString:(NSString *)symbolString;

+ (RKObjectMapping *)requestMapping;
+ (RKObjectMapping *)responseMapping;

- (NSMutableAttributedString*)cellFormatedRepresentation;

@end
