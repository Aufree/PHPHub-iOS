//
//  QNUserAgent.m
//  QiniuSDK
//
//  Created by bailong on 14-9-29.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED
  #import <MobileCoreServices/MobileCoreServices.h>
  #import <UIKit/UIKit.h>
#else
  #import <CoreServices/CoreServices.h>
#endif

#import "QNUserAgent.h"
#import "QNVersion.h"

static NSString *clientId(void) {
	long long now_timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
	int r = arc4random() % 1000;
	return [NSString stringWithFormat:@"%lld%u", now_timestamp, r];
}

static NSString *userAgent(NSString *id) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED
	return [NSString stringWithFormat:@"QiniuObject-C/%@ (%@; iOS %@; %@)", kQiniuVersion, [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], id];
#else
	return [NSString stringWithFormat:@"QiniuObject-C/%@ (Mac OS X %@; %@)", kQiniuVersion, [[NSProcessInfo processInfo] operatingSystemVersionString], id];
#endif
}

@interface QNUserAgent ()
@property (nonatomic) NSString *ua;
@end

@implementation QNUserAgent

- (NSString *)description {
	return _ua;
}

- (instancetype)init {
	if (self = [super init]) {
		_id = clientId();
		_ua = userAgent(_id);
	}
	return self;
}

/**
 *  单例
 */
+ (instancetype)sharedInstance {
	static QNUserAgent *sharedInstance = nil;

	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});

	return sharedInstance;
}

@end
