//
//  APIRequestHandler.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "APIRequestHandler.h"
#import "AccessTokenHandler.h"

@implementation APIRequestHandler

// Register Notification for HTTP Requests
- (void)registerNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkRequestDidStart:)
                                                 name:AFNetworkingOperationDidStartNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkRequestDidFinish:)
                                                 name:AFNetworkingOperationDidFinishNotification
                                               object:nil];
    
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkRequestDidStart:)
                                                 name:AFNetworkingTaskDidResumeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkRequestDidFinish:)
                                                 name:AFNetworkingTaskDidCompleteNotification
                                               object:nil];
#endif
}

// start
- (void)networkRequestDidStart:(NSNotification *)notification
{
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    if (!request) return;
    
    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
}

// finish
- (void)networkRequestDidFinish:(NSNotification *)notification
{
    NSURLRequest *request = AFNetworkRequestFromNotification(notification);
    NSURLResponse *response = [notification.object response];
    NSError *error = [notification.object error];
    
    if (!request && !response) {
        return;
    }
    
    NSUInteger responseStatusCode = 0;
    NSDictionary *responseHeaderFields = nil;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        responseStatusCode = (NSUInteger)[(NSHTTPURLResponse *)response statusCode];
        responseHeaderFields = [(NSHTTPURLResponse *)response allHeaderFields];
    }
    
    id responseObject = nil;
    if ([[notification object] respondsToSelector:@selector(responseString)]) {
        responseObject = [[notification object] responseString];
    } else if (notification.userInfo) {
        responseObject = notification.userInfo[AFNetworkingTaskDidCompleteSerializedResponseKey];
    }
    
    
    NSString *body = nil;
    if ([request HTTPBody]) {
        body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
    }
    
    if (error)
    {
        NSLog(@"[Network Error] %@ '%@' (%i) : %@ -------------> %@" , [request HTTPMethod], [[response URL] absoluteString], (int)responseStatusCode, error, response);
    }
    else
    {
        if (DEBUG_HTTP) {
            NSLog(@"---");
            NSLog(@"---");
            NSLog(@"---");
            NSLog(@"---");
            NSLog(@"-----------------------");
            NSLog(@"------ API Request -----");
            NSLog(@"-----------------------");
            NSLog(@"Request HTTP URL --->  %@", [[request URL] absoluteString]);
            NSLog(@"Request HTTP Method --->  %@", [request HTTPMethod]);
            NSLog(@"Request HTTP Headers --->  %@", [request allHTTPHeaderFields]);
            NSLog(@"Request HTTP Body --->  %@", body);
            NSLog(@"Request Token is --->  %@", [request valueForHTTPHeaderField:@"Authorization"]);
            NSLog(@"Request Grant Type is --->  %@", [self grantTypeFromRequest:request]);
            
            NSLog(@"-----------------------");
            NSLog(@"------ API Response -----");
            NSLog(@"-----------------------");
            NSLog(@"Respond HTTP Status Code ----->  %i", (int)responseStatusCode);
            NSLog(@"Respond HTTP URL ----->  '%@'", [[response URL] absoluteString]);
            NSLog(@"Respond HTTP Header -----> %@", responseHeaderFields);
            
            NSString *message = nil;
            if (responseObject && [responseObject isKindOfClass:NSDictionary.class]) {
                if (responseObject[@"message"]) {
                    message = responseObject[@"message"];
                }
            }
            if (message) {
                NSLog(@"Respond Message ----->  \"%@\"", message);
            }
            
            NSLog(@"---");
            NSLog(@"---");
            NSLog(@"---");
            NSLog(@"---");
        }
    }
    
    NSDictionary *userInfo = notification.userInfo;
    
    if (userInfo[AFNetworkingTaskDidCompleteErrorKey])
    {
        if ((int)responseStatusCode == 401)
        {
            NSString *message = responseObject[@"message"];
            if (
                [message isEqualToString:@"Access token is not valid"]
                || [message isEqualToString:@"Access token is missing"]
                )
            {
                
                // ------------ Token 不正确 ------------//
                
                // 1. 如果是 client_credentials 的请求的话, 发送 retry 3 次的请求
                if ([self isClientGrantRequest:request])
                {
                    [[CurrentUser Instance] setupClientRequestState:nil];
                }
                // 2. 如果是未知的 Token 的话, 如 : Barear <NULL>
                else if ([self isUnknowRequest:request])
                {
                    [[CurrentUser Instance] setupClientRequestState:nil];
                }
                else if ([self isLoginRequest:request])
                {
                    [JumpToOtherVCHandler jumpToLoginVC];
                    [[CurrentUser Instance] logOut];
                }
            }
        }
        
        if ((int)responseStatusCode == 403)
        {
            NSString *message = responseObject[@"error_message"];
            if ([message isEqualToString:@"Only access tokens representing client can use this endpoint"])
            {
//                [[CurrentUser Instance] setupClientRequestState];
                NSLog(@"AFNetworkingTaskDidCompleteErrorKey - %@", message);
                NSLog(@"---- 403 forbidden! You are using the wrong access token!");
            }
        }
        
        NSLog(@" --->  %@", userInfo[AFNetworkingTaskDidCompleteErrorKey]);
    }
}

#pragma mark -  helper method

static NSURLRequest * AFNetworkRequestFromNotification(NSNotification *notification) {
    NSURLRequest *request = nil;
    if ([[notification object] isKindOfClass:[AFURLConnectionOperation class]]) {
        request = [(AFURLConnectionOperation *)[notification object] request];
    } else if ([[notification object] respondsToSelector:@selector(originalRequest)]) {
        request = [[notification object] originalRequest];
    }
    return request;
}

- (BOOL)isUnknowRequest:(NSURLRequest *)request
{
    NSString *grantType = [self grantTypeFromRequest:request];
    return [grantType isEqualToString:@"unknow"];
}

- (BOOL)isPasswordRequest:(NSURLRequest *)request
{
    NSString *grantType = [self grantTypeFromRequest:request];
    return [grantType isEqualToString:@"password"];
}

- (BOOL)isLoginRequest:(NSURLRequest *)request
{
    NSString *grantType = [self grantTypeFromRequest:request];
    return [grantType isEqualToString:@"login_token"];
}

- (BOOL)isClientGrantRequest:(NSURLRequest *)request
{
    NSString *grantType = [self grantTypeFromRequest:request];
    return [grantType isEqualToString:@"client_credentials"];
}

- (NSString *)grantTypeFromRequest:(NSURLRequest *)request
{
    NSString *token = [request valueForHTTPHeaderField:@"Authorization"];
    
    if ([token isEqualToString:[AccessTokenHandler getClientGrantAccessTokenFromLocal]]) {
        return @"client_credentials";
    }
    
    if ([token isEqualToString:[AccessTokenHandler getLoginTokenGrantAccessToken]]) {
        return @"login_token";
    }
    
    return @"unknow";
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end