//
//  YFBaseResponse.h
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKObjectMapping;

@interface YFBaseResponse : NSObject

@property (nonatomic, strong) NSArray *resources;

+ (RKObjectMapping *)requestMapping;
+ (RKObjectMapping *)responseMapping;

@end
