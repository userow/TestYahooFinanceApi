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

- (void) getDefaultQuotesSuccess:(YFSuccessBlock)success failure:(YFFailureBlock)failure;
{
    NSArray *sym = [@"LNKD,AMZN,NFLX,FB,TWTR,YHOO,AAPL,INTC,GOOG" componentsSeparatedByString:@","];
    
    [self getQuotesBySymbols:sym success:success failure:failure];
}

- (void) getQuotesBySymbols:(NSArray *)symbols success:(YFSuccessBlock)success failure:(YFFailureBlock)failure;
{
    if (!(symbols && symbols.count)) return;
    
    NSDictionary *requestParametersDic = @{@"format":@"json", @"view" : @"detail", };
    
//    [self.objectManager getObjectsAtPath:requestPathString
//                              parameters:requestParametersDic
//                                 success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
//                                     RKLogInfo(@"Load collection of quotes: %@", mappingResult.array);
//                                 } failure:^(RKObjectRequestOperation *operation, NSError *error) {
//                                     RKLogError(@"Operation failed with error: %@", error);
//                                 }];
    
    
    // Get a user by user name.
    [[YFApiCalls sharedCalls].objectManager getObject:[YFQuote quoteWithSymbolString:[symbols componentsJoinedByString:@","]] path:nil parameters:requestParametersDic
                                       success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                           // Do something with mappingResult.array
                                           
                                           RKLogInfo(@"Load collection of quotes: %@", mappingResult.array);
                                       }
                                       failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                           // Do something
                                           RKLogError(@"Operation failed with error: %@", error);
                                       }];
}

- (void) getSymbolForName:(NSString *)name success:(YFSuccessBlock)success failure:(YFFailureBlock)failure;
{
    
    
}

@end
