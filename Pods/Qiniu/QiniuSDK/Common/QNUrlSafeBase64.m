//
//  QiniuSDK
//
//  Created by bailong on 14-9-28.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNUrlSafeBase64.h"

#import "GTM_Base64.h"

@implementation QNUrlSafeBase64

+ (NSString *)encodeString:(NSString *)sourceString {
	NSData *data = [NSData dataWithBytes:[sourceString UTF8String] length:[sourceString lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
	return [self encodeData:data];
}

+ (NSString *)encodeData:(NSData *)data {
	return [GTM_Base64 stringByWebSafeEncodingData:data padded:YES];
}

+ (NSData *)decodeString:(NSString *)data {
	return [GTM_Base64 webSafeDecodeString:data];
}

@end
