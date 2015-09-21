//
//  QNNetworkInfo.m
//  HappyDNS
//
//  Created by bailong on 15/6/25.
//  Copyright (c) 2015年 Qiniu Cloud Storage. All rights reserved.
//

#include <sys/socket.h>
#include <netinet/in.h>
#include <fcntl.h>
#include <unistd.h>
#import <arpa/inet.h>

#import "QNNetworkInfo.h"

const int kQNNO_NETWORK = -1;
const int kQNWIFI = 1;
const int kQNMOBILE = 2;

const int kQNISP_GENERAL = 0;
const int kQNISP_CTC = 1;
const int kQNISP_DIANXIN = kQNISP_CTC;
const int kQNISP_CNC = 2;
const int kQNISP_LIANTONG = kQNISP_CNC;
const int kQNISP_CMCC = 3;
const int kQNISP_YIDONG = kQNISP_CMCC;
const int kQNISP_OTHER = 999;

static char previousIp[32] = {0};
static NSString* lock = @"";
static int localIp(char *buf){
	int err;
	int sock;

	// Create the UDP socket itself.

	err = 0;
	sock = socket(AF_INET, SOCK_DGRAM, 0);
	if (sock < 0) {
		err = errno;
		return err;
	}


	struct sockaddr_in addr;

	memset(&addr, 0, sizeof(addr));

	inet_pton(AF_INET, "8.8.8.8", &addr.sin_addr);
	addr.sin_family = AF_INET;
	addr.sin_port = htons(53);
	err = connect(sock, (const struct sockaddr *) &addr, sizeof(addr));

	if (err < 0) {
		err = errno;
	}

	struct sockaddr_in localAddress;
	socklen_t addressLength = sizeof(struct sockaddr_in);
	err = getsockname(sock, (struct sockaddr*)&localAddress, &addressLength);
	close(sock);
	if (err != 0) {
		return err;
	}
	const char* ip = inet_ntop(AF_INET, &(localAddress.sin_addr), buf, 32);
	if (ip == nil) {
		return -1;
	}
	return 0;
}

@implementation QNNetworkInfo

- (instancetype)init:(int)connecton provider:(int)provider {
	if (self = [super init]) {
		_networkConnection = connecton;
		_provider = provider;
	}
	return self;
}

+ (instancetype)noNet {
	return [[QNNetworkInfo alloc] init:kQNNO_NETWORK provider:kQNISP_GENERAL];
}

+ (instancetype)normal {
	return [[QNNetworkInfo alloc] init:kQNISP_GENERAL provider:kQNISP_GENERAL];
}

- (BOOL)isEqualToInfo:(QNNetworkInfo *)info {
	if (self == info)
		return YES;
	return self.provider == info.provider && self.networkConnection == info.networkConnection;
}

- (BOOL)isEqual:(id)other {
	if (other == self)
		return YES;
	if (!other || ![other isKindOfClass:[self class]])
		return NO;
	return [self isEqualToInfo:other];
}

+ (BOOL) isNetworkChanged {
	@synchronized(lock){
		char local[32] = {0};
		int err = localIp(local);
		if (err != 0) {
			return YES;
		}
		if (memcmp(previousIp, local, 32)!=0) {
			memcpy(previousIp, local, 32);
			return YES;
		}
		return NO;
	}
}

+(NSString*)getIp {
	char buf[32] = {0};
	int err = localIp(buf);
	if (err != 0) {
		return nil;
	}
	return [NSString stringWithUTF8String:buf];
}
@end
