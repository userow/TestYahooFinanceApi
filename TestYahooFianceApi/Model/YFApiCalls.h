//
//  YFApiCalls.h
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^receivedBlock)(NSDictionary *receivedDict);
typedef void (^YFSuccessBlock)(id object);
typedef void (^YFFailureBlock)(NSError *error);

@interface YFApiCalls : NSObject


+ (YFApiCalls *)sharedCalls;

- (void) getDefaultQuotes;
- (void) getQuotesBySymbols:(NSArray *)symbols;
- (void) getSymbolForName:(NSString *)name;

@end
