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

+ (NSString *)getClientGrantAccessTokenFromLocal
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:APIClientTokenIdentifier];
    return [NSString stringWithFormat:@"Bearer %@", token];
}

+ (void)storeClientGrantAccessToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:APIClientTokenIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[BaseApi clientGrantInstance] setUpClientGrantRequest];
}

+ (void)fetchClientGrantToken
{
    NSURL *url = [NSURL URLWithString:APIBaseURL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:Client_id secret:Client_secret];
    
    [oauthClient authenticateUsingOAuthWithURLString:APIAccessToken
                                               scope:@""
                                             success: ^(AFOAuthCredential *credential) {
                                                 NSLog(@"oauthClient -- > I have a CLIENT GRANT token! %@", credential.accessToken);
                                                 [AccessTokenHandler storeClientGrantAccessToken:credential.accessToken];
                                             }
                                             failure: ^(NSError *error) {
                                                 NSLog(@" oauthClient --> Error: %@", error);
                                             }];
}

+ (void)fetchClientGrantTokenWithRetryTimes:(NSInteger)times callback:(BaseResultBlock)block
{
    NSURL *url = [NSURL URLWithString:APIBaseURL];
    AFOAuth2Client *oauthClient = [AFOAuth2Client clientWithBaseURL:url clientID:Client_id secret:Client_secret];
    
    [oauthClient authenticateUsingOAuthWithURLString:APIAccessToken
                                               scope:@""
                                             success: ^(AFOAuthCredential *credential)
     {
         NSLog(@"oauthClient -- > I have a CLIENT GRANT token! %@", credential.accessToken);
         [AccessTokenHandler storeClientGrantAccessToken:credential.accessToken];
         if (block) block(@{@"access_token": credential.accessToken}, nil);
     }
                                             failure: ^(NSError *error)
     {
         if (times > 0)
         {
             NSInteger newRetryTime = times - 1;
             [self fetchClientGrantTokenWithRetryTimes:newRetryTime callback:block];
         }
         else
         {
             if (block) block(nil, error);
         }
         NSLog(@" oauthClient --> Error: %@", error);
     }];
}

#pragma mark - Password Grant

+ (NSString *)getPasswordGrantAccessToken
{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:APIPasswordTokenIdentifier];
    return [NSString stringWithFormat:@"Bearer %@", token];
}
+ (void)storePasswordGrantAccessToken:(NSString *)token
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:APIPasswordTokenIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[BaseApi clientGrantInstance] setUpPasswordGrantRequest];
}

+ (void)clearToken
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:APIPasswordTokenIdentifier];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:APIClientTokenIdentifier];
}

@end
