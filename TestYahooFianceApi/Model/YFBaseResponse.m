//
//  YFBaseResponse.m
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import "YFBaseResponse.h"

#import <RestKit/RestKit.h>

@implementation YFBaseResponse

+ (RKObjectMapping *)requestMapping {
    return [[YFBaseResponse responseMapping] inverseMapping];
}

+ (RKObjectMapping *)responseMapping {
    RKObjectMapping *result = [RKObjectMapping mappingForClass:[YFBaseResponse class]];
    [result addAttributeMappingsFromDictionary:@{
                                                 @"resources" : @"resources",
                                                 }];
    return result;
}

@end