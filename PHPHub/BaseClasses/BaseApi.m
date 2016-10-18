//
//  BaseApi.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseApi.h"
#import "AccessTokenHandler.h"

@implementation BaseApi
#pragma mark - Share Instance

+ (instancetype)loginTokenGrantInstance {
    static BaseApi *_passwordGrantInstance = nil;
    static dispatch_once_t passwordGrantOnceToken;
    dispatch_once(&passwordGrantOnceToken, ^{
        _passwordGrantInstance = [[BaseApi alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURL]];
        
        [_passwordGrantInstance prepareForCommonRequest];
        [_passwordGrantInstance setUpLoginTokenGrantRequest];
    });
    return _passwordGrantInstance;
}

+ (instancetype)clientGrantInstance {
    static BaseApi *_clientGrantInstance = nil;
    static dispatch_once_t clientGrantOnceToken;
    dispatch_once(&clientGrantOnceToken, ^{
        _clientGrantInstance = [[BaseApi alloc] initWithBaseURL:[NSURL URLWithString:APIBaseURL]];
        
        [_clientGrantInstance prepareForCommonRequest];
        [_clientGrantInstance setUpClientGrantRequest];
    });
    return _clientGrantInstance;
}

#pragma mark - Helper

- (void)prepareForCommonRequest {
    NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
    NSString *buildNumber = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    [self.requestSerializer setValue:@"application/vnd.PHPHub.v1+json" forHTTPHeaderField:@"Accept"];
    [self.requestSerializer setValue:@"iOS" forHTTPHeaderField:@"X-Client-Platform"];
    [self.requestSerializer setValue:version forHTTPHeaderField:@"X-Client-Version"];
    [self.requestSerializer setValue:buildNumber forHTTPHeaderField:@"X-Client-Build"];
    [self.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
    self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    self.handler = [[APIRequestHandler alloc] init];
    [self.handler registerNotifications];
}

- (void)setUpLoginTokenGrantRequest {
    [self.requestSerializer setValue:[AccessTokenHandler getLoginTokenGrantAccessToken]
                  forHTTPHeaderField:@"Authorization"];
    self.handler.grantType = @"login_token";
}

- (void)setUpClientGrantRequest {
    [self.requestSerializer setValue:[AccessTokenHandler getClientGrantAccessTokenFromLocal]
                  forHTTPHeaderField:@"Authorization"];
    self.handler.grantType = @"client_credentials";
}

#pragma mark - Abstract Method

- (id)create:(id)entity withBlock:(BaseResultBlock)block {
    NSLog(@"You must override %@ in a subclass",NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)update:(id)entity withBlock:(BaseResultBlock)block {
    NSLog(@"You must override %@ in a subclass",NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)upvote:(id)entity withBlock:(BaseResultBlock)block {
    NSLog(@"You must override %@ in a subclass",NSStringFromSelector(_cmd));
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
