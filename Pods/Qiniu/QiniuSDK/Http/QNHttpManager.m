//
//  QNHttpManager.m
//  QiniuSDK
//
//  Created by bailong on 14/10/1.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "AFNetworking.h"

#import "QNConfiguration.h"
#import "QNHttpManager.h"
#import "QNUserAgent.h"
#import "QNResponseInfo.h"
#import "QNDns.h"
#import "HappyDNS.h"

@interface QNHttpManager ()
@property (nonatomic) AFHTTPRequestOperationManager *httpManager;
@property UInt32 timeout;
@property (nonatomic, strong) QNUrlConvert converter;
@property (nonatomic) QNDnsManager *dns;
@end

const int kQNRetryConnectTimes = 3;

static NSURL *buildUrl(NSString *host, NSNumber *port, NSString *path){
    port = port == nil? [NSNumber numberWithInt:80]:port;
    NSString *p = [[NSString alloc] initWithFormat:@"http://%@:%@%@", host, port, path];
    return [[NSURL alloc] initWithString:p];
}

static BOOL needRetry(AFHTTPRequestOperation *op, NSError *error){
    if (error != nil) {
        return error.code < -1000;
    }
    if (op == nil) {
        return YES;
    }
    int status = (int)[op.response statusCode];
    return status >= 500 && status < 600 && status != 579;
}

@implementation QNHttpManager

- (instancetype)initWithTimeout:(UInt32)timeout
                   urlConverter:(QNUrlConvert)converter
                       dns:(QNDnsManager *)dns {
	if (self = [super init]) {
		_httpManager = [[AFHTTPRequestOperationManager alloc] init];
		_httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
		_timeout = timeout;
		_converter = converter;
		_dns = dns;
	}

	return self;
}

- (instancetype)init {
	return [self initWithTimeout:60 urlConverter:nil dns:nil];
}

+ (QNResponseInfo *)buildResponseInfo:(AFHTTPRequestOperation *)operation
                            withError:(NSError *)error
                         withDuration:(double)duration
                         withResponse:(id)responseObject
                               withIp:(NSString *)ip {
	QNResponseInfo *info;
	NSString *host = operation.request.URL.host;

	if (operation.response) {
		int status =  (int)[operation.response statusCode];
		NSDictionary *headers = [operation.response allHeaderFields];
		NSString *reqId = headers[@"X-Reqid"];
		NSString *xlog = headers[@"X-Log"];
		NSString *xvia = headers[@"X-Via"];
		if (xvia == nil) {
			xvia = headers[@"X-Px"];
		}
		info = [[QNResponseInfo alloc] init:status withReqId:reqId withXLog:xlog withXVia:xvia withHost:host withIp:ip withDuration:duration withBody:responseObject];
	}
	else {
		info = [QNResponseInfo responseInfoWithNetError:error host:host duration:duration];
	}
	return info;
}

- (void)  sendRequest2:(NSMutableURLRequest *)request
     withCompleteBlock:(QNCompleteBlock)completeBlock
     withProgressBlock:(QNInternalProgressBlock)progressBlock
       withCancelBlock:(QNCancelBlock)cancelBlock
           withIpArray:(NSArray*)ips
             withIndex:(int)index
            withDomain:(NSString *)domain
        withRetryTimes:(int)times
         withStartTime:(NSDate *)startTime{
    NSURL *url = request.URL;
    __block NSString *ip = nil;
    if(ips != nil){
        ip = [ips objectAtIndex:(index%ips.count)];
        NSString *path = url.path;
        if (path == nil || [@"" isEqualToString:path]) {
            path = @"/";
        }
        url = buildUrl(ip, url.port, path);
        [request setValue:domain forHTTPHeaderField:@"Host"];
        
    }
    
    request.URL = url;
    
    AFHTTPRequestOperation *operation = [_httpManager
                                         HTTPRequestOperationWithRequest:request
                                         success: ^(AFHTTPRequestOperation *operation, id responseObject) {
                                             double duration = [[NSDate date] timeIntervalSinceDate:startTime];
                                             QNResponseInfo *info = [QNHttpManager buildResponseInfo:operation withError:nil withDuration:duration withResponse:operation.responseData withIp:ip];
                                             NSDictionary *resp = nil;
                                             if (info.isOK) {
                                                 resp = responseObject;
                                             }
                                             NSLog(@"success %@", info);
                                             completeBlock(info, resp);
                                         }                                                                failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
                                             if (_converter != nil && (index+1 < ips.count || times>0) && needRetry(operation, error)) {
                                                 [self sendRequest2:request withCompleteBlock:completeBlock withProgressBlock:progressBlock withCancelBlock:cancelBlock withIpArray:ips withIndex:index+1 withDomain:domain withRetryTimes:times -1 withStartTime:startTime];
                                                 return;
                                             }
                                             double duration = [[NSDate date] timeIntervalSinceDate:startTime];
                                             QNResponseInfo *info = [QNHttpManager buildResponseInfo:operation withError:error withDuration:duration withResponse:operation.responseData withIp:ip];
                                             NSLog(@"failure %@", info);
                                             completeBlock(info, nil);
                                         }
                                         ];
    
    if (progressBlock || cancelBlock) {
        __block AFHTTPRequestOperation *op = nil;
        if (cancelBlock) {
            op = operation;
        }
        [operation setUploadProgressBlock: ^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            if (progressBlock) {
                progressBlock(totalBytesWritten, totalBytesExpectedToWrite);
            }
            if (cancelBlock) {
                if (cancelBlock()) {
                    [op cancel];
                }
                op = nil;
            }
        }];
    }
    [request setTimeoutInterval:_timeout];
    
    [request setValue:[[QNUserAgent sharedInstance] description] forHTTPHeaderField:@"User-Agent"];
    [request setValue:nil forHTTPHeaderField:@"Accept-Language"];
    [_httpManager.operationQueue addOperation:operation];
}

- (void)  sendRequest:(NSMutableURLRequest *)request
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock{
    NSString *u = request.URL.absoluteString;
    NSURL *url = request.URL;
    NSString *domain =url.host;
    NSArray * ips = nil;
    NSDate *startTime = [NSDate date];
    if (_converter != nil) {
        url = [[NSURL alloc] initWithString:_converter(u)];
        request.URL = url;
        domain = url.host;
    } else if(_dns != nil){
        ips = [_dns queryWithDomain:[[QNDomain alloc] init:domain hostsFirst:NO hasCname:YES maxTtl:1000]];
        if (ips == nil || ips.count == 0) {
            NSError *error = [[NSError alloc] initWithDomain:domain code:-1003 userInfo:@{ @"error":@"unkonwn host" }];
             double duration = [[NSDate date] timeIntervalSinceDate:startTime];
            QNResponseInfo *info = [QNResponseInfo responseInfoWithNetError:error host:domain duration:duration];
            NSLog(@"failure %@", info);
            completeBlock(info, nil);
            return;
        }
    }
    [self sendRequest2:request withCompleteBlock:completeBlock withProgressBlock:progressBlock withCancelBlock:cancelBlock withIpArray:ips withIndex:0 withDomain:domain withRetryTimes:kQNRetryConnectTimes withStartTime:startTime];
    
}

- (void)multipartPost:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
         withFileName:(NSString *)key
         withMimeType:(NSString *)mime
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock{
	NSMutableURLRequest *request = [_httpManager.requestSerializer
	                                multipartFormRequestWithMethod:@"POST"
	                                                     URLString:url
	                                                    parameters:params
	                                     constructingBodyWithBlock: ^(id < AFMultipartFormData > formData) {
	    [formData appendPartWithFileData:data name:@"file" fileName:key mimeType:mime];
	}

	                                                         error:nil];
	[self sendRequest:request
	    withCompleteBlock:completeBlock
	    withProgressBlock:progressBlock
     withCancelBlock:cancelBlock];
}

- (void)         post:(NSString *)url
             withData:(NSData *)data
           withParams:(NSDictionary *)params
          withHeaders:(NSDictionary *)headers
    withCompleteBlock:(QNCompleteBlock)completeBlock
    withProgressBlock:(QNInternalProgressBlock)progressBlock
      withCancelBlock:(QNCancelBlock)cancelBlock{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:url]];
	if (headers) {
		[request setAllHTTPHeaderFields:headers];
	}

	[request setHTTPMethod:@"POST"];

	if (params) {
		[request setValuesForKeysWithDictionary:params];
	}
	[request setHTTPBody:data];
	[self sendRequest:request
	    withCompleteBlock:completeBlock
	    withProgressBlock:progressBlock
     withCancelBlock:cancelBlock];
}

@end
