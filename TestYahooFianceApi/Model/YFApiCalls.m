//
//  YFApiCalls.m
//  TestYahooFianceApi
//
//  Created by Pavel Wasilenko on 160224.
//  Copyright © 2016 Pavel Wasilenko. All rights reserved.
//

#import <RestKit/RestKit.h>
#import "YFApiCalls.h"
#import "YFQuote.h"

static NSString *serverUrl = @"http://finance.yahoo.com/webservice/v1/";

@interface YFApiCalls ()

@property (nonatomic, strong) RKObjectManager *objectManager;
@property (nonatomic, copy)   receivedBlock complitionBlock;

@property (atomic, strong) __block NSArray *defaultQuotes;

@end

@implementation YFApiCalls

+ (YFApiCalls *)sharedCalls {
    
    static YFApiCalls *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YFApiCalls alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSURL *baseUrl = [NSURL URLWithString:serverUrl];
        self.objectManager = [RKObjectManager managerWithBaseURL:baseUrl];
        [self setupDescriptors];
    }
    
    return self;
}
#pragma mark - Private
- (void) setupDescriptors {

    // Get quotes by symbols route. We create a class route here.
    RKObjectMapping *quoteMapping = [YFQuote responseMapping];

    RKResponseDescriptor *quotesResponseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:quoteMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"symbols/:symbolString/quote"
                                                keyPath:@"list.resources"
                                            statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful)];
    
    [self.objectManager addResponseDescriptor:quotesResponseDescriptor];
    
    [self.objectManager.router.routeSet
     addRoute:[RKRoute routeWithClass:[YFQuote class]
                          pathPattern:@"symbols/:symbolString/quote"
                               method:RKRequestMethodGET]];

}

#pragma mark - Public

- (void) getDefaultQuotes;
{
    NSArray *sym = [@"LNKD,AMZN,NFLX,FB,TWTR,YHOO,AAPL,INTC,GOOG" componentsSeparatedByString:@","];
    
    [self getQuotesBySymbols:sym];
}

- (void) getQuotesBySymbols:(NSArray *)symbols;
{
    if (!(symbols && symbols.count)) return;
    
    NSString *requestPathString = [NSString stringWithFormat:@"symbols/:quotes/quote", [symbols componentsJoinedByString:@","]];
    
    
    NSDictionary *requestParametersDic = @{@"format":@"json", @"view" : @"detail", };
    
    [self.objectManager getObjectsAtPath:requestPathString
                              parameters:requestParametersDic
                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                     RKLogInfo(@"Load collection of quotes: %@", mappingResult.array);
                                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                     RKLogError(@"Operation failed with error: %@", error);
                                 }];
}

- (void) getSymbolForName:(NSString *)name;
{
    
    
}

@end
