//
//  QNDns.m
//  QiniuSDK
//
//  Created by bailong on 15/1/2.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <arpa/inet.h>

#import "QNDns.h"

static NSArray *getAddresses(CFHostRef hostRef) {
	Boolean lookup = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
	if (!lookup) {
		return nil;
	}
	CFArrayRef addresses = CFHostGetAddressing(hostRef, &lookup);
	if (!lookup) {
		return nil;
	}

	char buf[32];
	__block NSMutableArray *ret = [[NSMutableArray alloc] init];

	// Iterate through the records to extract the address information
	struct sockaddr_in *remoteAddr;
	for (int i = 0; i < CFArrayGetCount(addresses); i++) {
		CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
		remoteAddr = (struct sockaddr_in *)CFDataGetBytePtr(saData);

		if (remoteAddr != NULL) {
			const char *p = inet_ntop(AF_INET, &(remoteAddr->sin_addr), buf, 32);
			NSString *ip = [NSString stringWithUTF8String:p];
			[ret addObject:ip];
//			NSLog(@"Resolved %u->%@", i, ip);
		}
	}
	return ret;
}

@implementation QNDns

+ (NSArray *)getAddresses:(NSString *)hostName {
	// Convert the hostname into a StringRef
	CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, [hostName UTF8String], kCFStringEncodingASCII);

	CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
	NSArray *ret = getAddresses(hostRef);

	CFRelease(hostRef);
	CFRelease(hostNameRef);
	return ret;
}

+ (NSString *)getAddress:(NSString *)hostName {
	NSArray *result = [QNDns getAddresses:hostName];
	if (result == nil || result.count == 0) {
		return @"";
	}
	return result[0];
}

+ (NSString *)getAddressesString:(NSString *)hostName {
	NSArray *result = [QNDns getAddresses:hostName];
	if (result == nil || result.count == 0) {
		return @"";
	}
	return [result componentsJoinedByString:@";"];
}

@end
