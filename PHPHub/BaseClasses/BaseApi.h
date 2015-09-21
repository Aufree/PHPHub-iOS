//
//  BaseApi.h
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "APIRequestHandler.h"

typedef void (^ BaseResultBlock)(id data, NSError *error);
typedef void (^ BaseRequestSuccessBlock)(NSURLSessionDataTask *task, id responseObject);
typedef void (^ BaseRequestFailureBlock)(NSURLSessionDataTask *task, NSError *error);
typedef void (^ BaseRequestConstructingBodyBlock)(id<AFMultipartFormData> formData);

@interface BaseApi : AFHTTPSessionManager

@property(strong,nonatomic) APIRequestHandler* handler;

#pragma mark - Share Instance

+ (instancetype)passwordGrantInstance;
+ (instancetype)clientGrantInstance;

#pragma mark - Public Method

- (void)setUpPasswordGrantRequest;
- (void)setUpClientGrantRequest;

#pragma mark - Shared/Inherit Method

- (id)create:(id)entity withBlock:(BaseResultBlock)block;
- (id)update:(id)entity withBlock:(BaseResultBlock)block;
- (id)upvote:(id)entity withBlock:(BaseResultBlock)block;
@end
