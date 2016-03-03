//
//  YFQuote.m
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import "YFQuote.h"
#import <RestKit/RestKit.h>
#import <UIKit/UIKit.h>

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
    
    NSString * des = [NSString stringWithFormat:@""
    "<\r"
    "name           = %@\r"
    "symbol         = %@\r"
    "change         = %@\r"
    "changePercent  = %@\r"
    "dayHigh        = %@\r"
    "dayLow         = %@\r"
    "price          = %@\r"
    ">",
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

- (BOOL)isRising
{
    return [self.change floatValue] > 0;
}

-(BOOL)isNoChange
{
    return [self.change floatValue] == 0;
}

/*
 name           = Amazon.com, Inc.
 symbol         = AMZN
 change         = 26.519958
 changePercent  = 4.799819
 dayHigh        = 579.25
 dayLow         = 556
 price          = 579.039978
*/

//Каждая ячейка должна содержать имя индекса, информацию о его текущей цене, динамике, цене закрытия, самый низкий и высокий показатель в текущий день торгов.
- (NSMutableAttributedString*)cellFormatedRepresentation;
{

    
    //Amazon.com, Inc. (AMZN) 579.039978 ∆ 4.79 %
    //Hi: 579.25 Lo: 556 Close:
    
    NSString * result = [NSString stringWithFormat:@""
                         "%@ (%@)\n"
                         "%1.4f %@[%1.2f]\n"
                         "Hi: %1.2f Lo: %1.2f",
                         self.name,
                         self.symbol,
                         [self.price floatValue],
                         self.isNoChange ? @"" : (self.isRising ? @"\u25B2" : @"\u25BC"),
                         [self.changePercent floatValue],
                         [self.dayHigh floatValue],
                         [self.dayLow floatValue]
    ];
    
    NSDictionary *textAttributes = @{ (NSString *)NSFontAttributeName : [UIFont systemFontOfSize:12]};
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:result attributes:textAttributes];
    
    
    if (!self.isNoChange) {
        NSRange changeRange = [result rangeOfString:@"["];
        
        [attributedString addAttribute:NSForegroundColorAttributeName value:(self.isRising? [UIColor greenColor] : [UIColor redColor])
                                 range:NSMakeRange(changeRange.location -1 , 1) ];
    }
    
    return attributedString;
}

@end
