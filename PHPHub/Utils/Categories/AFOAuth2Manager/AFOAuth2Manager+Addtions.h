//
//  AFOAuth2Manager+Addtions.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "AFOAuth2Manager.h"

@interface AFOAuth2Manager (Addtions)
- (AFHTTPRequestOperation *)authenticateUsingOAuthWithURLString:(NSString *)URLString
                                                       username:(NSString *)username
                                                     loginToken:(NSString *)loginToken
                                                          scope:(NSString *)scope
                                                        success:(void (^)(AFOAuthCredential *credential))success
                                                        failure:(void (^)(NSError *error))failure;
@end
