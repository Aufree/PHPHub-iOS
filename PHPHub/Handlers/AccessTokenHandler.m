//
//  AccessTokenHandler.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "AccessTokenHandler.h"
#import "SSKeychain.h"

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
    NSString *token = [SSKeychain passwordForService:KeyChainService account:KeyChainAccount];
    return [NSString stringWithFormat:@"Bearer %@", token];
}

+ (void)storeLoginTokenGrantAccessToken:(NSString *)token {
    [SSKeychain setPassword:token forService:KeyChainService account:KeyChainAccount];
    [[BaseApi loginTokenGrantInstance] setUpLoginTokenGrantRequest];
}

+ (void)clearToken {
    [SSKeychain deletePasswordForService:KeyChainService account:KeyChainAccount];
    [GVUserDefaults standardUserDefaults].userClientToken = nil;
}

@end
