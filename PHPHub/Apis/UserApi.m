//
//  UserApi.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "UserApi.h"

@implementation UserApi

- (id)getCurrentUserData:(BaseResultBlock)block {
    NSString *urlPath = [NSString stringWithFormat:@"me"];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entity"] = [UserEntity entityFromDictionary:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    return [[BaseApi loginTokenGrantInstance] GET:urlPath
                                       parameters:nil
                                          success:successBlock
                                          failure:failureBlock];
}

- (id)getUserById:(NSNumber *)userId callback:(BaseResultBlock)block {
    NSString *urlPath = [NSString stringWithFormat:@"users/%@", userId];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entity"] = [UserEntity entityFromDictionary:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    return [[BaseApi clientGrantInstance] GET:urlPath
                                       parameters:nil
                                          success:successBlock
                                          failure:failureBlock];
}

- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block {
    NSURL *url = [NSURL URLWithString:APIBaseURL];
    AFOAuth2Manager *oauthClient = [AFOAuth2Manager clientWithBaseURL:url clientID:Client_id secret:Client_secret];

    [oauthClient authenticateUsingOAuthWithURLString:APIAccessTokenURL
                                            username:username
                                          loginToken:loginToken
                                               scope:@""
                                             success:^(AFOAuthCredential *credential) {
                                                 if (block) block(@{@"access_token": credential.accessToken}, nil);
                                             } failure:^(NSError *error) {
                                                 if (block) block(nil, error);
                                             }];
    return nil;
}

- (id)updateUserProfile:(UserEntity *)user withBlock:(BaseResultBlock)block {
    NSString *urlPath = [NSString stringWithFormat:@"users/%@", [CurrentUser Instance].userId];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        if (data[@"data"]) {
            data[@"entity"] = [UserEntity entityFromDictionary:data[@"data"]];
        }
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    return [[BaseApi loginTokenGrantInstance] PUT:urlPath
                                   parameters:[user transformToDictionary]
                                      success:successBlock
                                      failure:failureBlock];
}
@end
