//
//  YFApiCalls.h
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^YFSuccessBlock)(id object);
typedef void (^YFFailureBlock)(NSError *error);

@interface YFApiCalls : NSObject

//@property (atomic, strong) __block NSArray *defaultQuotes;

+ (YFApiCalls *)sharedCalls;

- (instancetype)init NS_UNAVAILABLE;

- (void) getDefaultQuotesSuccess:(YFSuccessBlock)success failure:(YFFailureBlock)failure;
- (void) getQuotesBySymbols:(NSArray *)symbols success:(YFSuccessBlock)success failure:(YFFailureBlock)failure;
- (void) getSymbolForName:(NSString *)name success:(YFSuccessBlock)success failure:(YFFailureBlock)failure;

@end
