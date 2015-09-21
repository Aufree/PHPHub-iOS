//
//  QNUploadOption.m
//  QiniuSDK
//
//  Created by bailong on 14/10/4.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "QNUploadOption+Private.h"
#import "QNUploadManager.h"

static NSString *mime(NSString *mimeType) {
	if (mimeType == nil || [mimeType isEqualToString:@""]) {
		return @"application/octet-stream";
	}
	return mimeType;
}

@implementation QNUploadOption

+ (NSDictionary *)filteParam:(NSDictionary *)params {
	NSMutableDictionary *ret = [NSMutableDictionary dictionary];
	if (params == nil) {
		return ret;
	}

	[params enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSString *obj, BOOL *stop) {
	         if ([key hasPrefix:@"x:"] && ![obj isEqualToString:@""]) {
	                 ret[key] = obj;
		 }
	 }];

	return ret;
}

- (instancetype)initWithProgessHandler:(QNUpProgressHandler)progress {
	return [self initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
}

- (instancetype)initWithMime:(NSString *)mimeType
             progressHandler:(QNUpProgressHandler)progress
                      params:(NSDictionary *)params
                    checkCrc:(BOOL)check
          cancellationSignal:(QNUpCancellationSignal)cancel {
	if (self = [super init]) {
		_mimeType = mime(mimeType);
		_progressHandler = progress != nil ? progress : ^(NSString *key, float percent) {
		};
		_params = [QNUploadOption filteParam:params];
		_checkCrc = check;
		_cancellationSignal = cancel != nil ? cancel : ^BOOL () {
			return NO;
		};
	}

	return self;
}

+ (instancetype)defaultOptions {
	return [[QNUploadOption alloc] initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
}

@end
