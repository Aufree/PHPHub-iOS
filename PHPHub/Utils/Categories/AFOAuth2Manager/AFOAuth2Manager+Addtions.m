//
//  AFOAuth2Manager+Addtions.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

NSString * const kAFOAuthLoginTokenCredentialsGrantType = @"login_token";

#import "AFOAuth2Manager+Addtions.h"

@implementation AFOAuth2Manager (Addtions)
- (AFHTTPRequestOperation *)authenticateUsingOAuthWithURLString:(NSString *)URLString
                                                       username:(NSString *)username
                                                       loginToken:(NSString *)loginToken
                                                          scope:(NSString *)scope
                                                        success:(void (^)(AFOAuthCredential *credential))success
                                                        failure:(void (^)(NSError *error))failure
{
    NSParameterAssert(username);
    NSParameterAssert(scope);
    
    NSDictionary *parameters = @{
                                 @"grant_type": kAFOAuthLoginTokenCredentialsGrantType,
                                 @"username": username,
                                 @"login_token": loginToken,
                                 @"scope": scope
                                 };
    
    return [self authenticateUsingOAuthWithURLString:URLString parameters:parameters success:success failure:failure];
}

@end
