//
//  YFQuote.m
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import "YFQuote.h"
#import <RestKit/RestKit.h>

@implementation YFQuote

+(instancetype)quoteWithSymbolString:(NSString *)symbolString;
{
    YFQuote * quote = [YFQuote new];
    quote.symbolString = symbolString;
    
    return quote;
}

+ (RKObjectMapping *)requestMapping; {
    return [[YFQuote responseMapping] inverseMapping];
}

+ (RKObjectMapping *)responseMapping; {
    
    RKObjectMapping *quoteMaping = [RKObjectMapping mappingForClass:[YFQuote class]];
    [quoteMaping addAttributeMappingsFromDictionary:@{
                             @"resource.fields.change" : @"change",
                             @"resource.fields.chg_percent" : @"changePercent",
                             @"resource.fields.day_high" : @"dayHigh",
                             @"resource.fields.day_low" : @"dayLow",
                             @"resource.fields.price" : @"price",
                             @"resource.fields.symbol" : @"symbol",
                             @"resource.fields.name" : @"name",
                             @"symbolString" : @"symbolString"
                                                 }];
    
    return quoteMaping;
}

- (NSString *)description {
    
    NSString * des = [NSString stringWithFormat:@"\r"
    "<\r"
    "name           = %@\r"
    "symbol         = %@\r"
    "change         = %@\r"
    "changePercent  = %@\r"
    "dayHigh        = %@\r"
    "dayLow         = %@\r"
    "price          = %@\r"
    ">\r",
    self.name,
    self.symbol,
    self.change,
    self.changePercent,
    self.dayHigh,
    self.dayLow,
    self.price
                      ];

    
    return des;
}
@end
