//
//  AccessTokenHandler.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "AccessTokenHandler.h"

@implementation AccessTokenHandler
#pragma mark - Client Grant

+ (NSString *)getClientGrantAccessTokenFromLocal {
    NSString *token = [GVUserDefaults standardUserDefaults].userClientToken;
    return [NSString stringWithFormat:@"Bearer %@", token];
}

+ (void)storeClientGrantAccessToken:(NSString *)token {
    [GVUserDefaults standardUserDefaults].userClientToken = token;    
    [[BaseApi clientGrantInstance] setUpClientGrantRequest];
}

+ (void)fetchClientGrantToken {
    NSURL *url = [NSURL URLWithString:APIBaseURL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:Client_id secret:Client_secret];
    
    [oauthClient authenticateUsingOAuthWithURLString:APIAccessTokenURL
                                               scope:@""
                                             success: ^(AFOAuthCredential *credential) {
                                                 NSLog(@"oauthClient -- > I have a CLIENT GRANT token! %@", credential.accessToken);
                                                 [AccessTokenHandler storeClientGrantAccessToken:credential.accessToken];
                                             }
                                             failure: ^(NSError *error) {
                                                 NSLog(@" oauthClient --> Error: %@", error);
                                             }];
}

+ (void)fetchClientGrantTokenWithRetryTimes:(NSInteger)times callback:(BaseResultBlock)block {
    NSURL *url = [NSURL URLWithString:APIBaseURL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:Client_id secret:Client_secret];
    
    [oauthClient authenticateUsingOAuthWithURLString:APIAccessTokenURL
                                               scope:@""
                                             success: ^(AFOAuthCredential *credential) {
         NSLog(@"oauthClient -- > I have a CLIENT GRANT token! %@", credential.accessToken);
         [AccessTokenHandler storeClientGrantAccessToken:credential.accessToken];
         if (block) block(@{@"access_token": credential.accessToken}, nil);
     }
                                             failure: ^(NSError *error) {
         if (times > 0) {
             NSInteger newRetryTime = times - 1;
             [self fetchClientGrantTokenWithRetryTimes:newRetryTime callback:block];
         } else {
             if (block) block(nil, error);
         }
         NSLog(@" oauthClient --> Error: %@", error);
     }];
}

#pragma mark - Password Grant

+ (NSString *)getLoginTokenGrantAccessToken {
    NSString *token = [GVUserDefaults standardUserDefaults].userLoginToken;
    return [NSString stringWithFormat:@"Bearer %@", token];
}

+ (void)storeLoginTokenGrantAccessToken:(NSString *)token {
    [GVUserDefaults standardUserDefaults].userLoginToken = token;
    [[BaseApi clientGrantInstance] setUpLoginTokenGrantRequest];
}

+ (void)clearToken {
    [GVUserDefaults standardUserDefaults].userLoginToken = nil;
    [GVUserDefaults standardUserDefaults].userClientToken = nil;
}

@end
