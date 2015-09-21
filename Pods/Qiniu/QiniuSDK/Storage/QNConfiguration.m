//
//  QNConfiguration.m
//  QiniuSDK
//
//  Created by bailong on 15/5/21.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import "QNConfiguration.h"
#import "QNNetworkInfo.h"


const UInt32 kQNBlockSize = 4 * 1024 * 1024;

static QNDnsManager* initDns(QNConfigurationBuilder *builder) {
	QNDnsManager *d = builder.dns;
	if (d == nil) {
		id<QNResolverDelegate> r1 = [QNResolver systemResolver];
		id<QNResolverDelegate> r2 = [[QNResolver alloc] initWithAddres:@"223.6.6.6"];
		id<QNResolverDelegate> r3 = [[QNResolver alloc] initWithAddres:@"114.114.115.115"];
		d = [[QNDnsManager alloc] init:[NSArray arrayWithObjects:r1,r2, r3, nil] networkInfo:[QNNetworkInfo normal ]];
	}
	[d putHosts:builder.zone.upHost ip:builder.zone.upIp];
	[d putHosts:builder.zone.upHost ip:builder.zone.upIp2];
	[d putHosts:builder.zone.upHostBackup ip:builder.zone.upIp];
	[d putHosts:builder.zone.upHostBackup ip:builder.zone.upIp2];
	return d;
}

@implementation QNConfiguration

+ (instancetype)build:(QNConfigurationBuilderBlock)block {
	QNConfigurationBuilder *builder = [[QNConfigurationBuilder alloc] init];
	block(builder);
	return [[QNConfiguration alloc] initWithBuilder:builder];
}

- (instancetype)initWithBuilder:(QNConfigurationBuilder *)builder {
	if (self = [super init]) {
		_upHost = builder.zone.upHost;
		_upHostBackup = builder.zone.upHostBackup;

		_upPort = builder.upPort;

		_chunkSize = builder.chunkSize;
		_putThreshold = builder.putThreshold;
		_retryMax = builder.retryMax;
		_timeoutInterval = builder.timeoutInterval;

		_recorder = builder.recorder;
		_recorderKeyGen = builder.recorderKeyGen;

		_proxy = builder.proxy;

		_converter = builder.converter;
		if (builder.converter == nil) {
			_upIp = builder.zone.upIp;
		}

		_dns = initDns(builder);
	}
	return self;
}

@end

@implementation QNConfigurationBuilder

- (instancetype)init {
	if (self = [super init]) {
		_zone = [QNZone zone0];
		_chunkSize = 256 * 1024;
		_putThreshold = 512 * 1024;
		_retryMax = 2;
		_timeoutInterval = 60;

		_recorder = nil;
		_recorderKeyGen = nil;

		_proxy = nil;
		_converter = nil;

		_upPort = 80;
	}
	return self;
}

@end

@implementation QNZone

- (instancetype)initWithUpHost:(NSString *)upHost
                  upHostBackup:(NSString *)upHostBackup
                          upIp:(NSString *)upIp
                         upIp2:(NSString*)upIp2; {
	if (self = [super init]) {
		_upHost = upHost;
		_upHostBackup = upHostBackup;
		_upIp = upIp;
		_upIp2 = upIp2;
	}

	return self;
}

+ (instancetype)zone0 {
	static QNZone *z0 = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		z0 = [[QNZone alloc] initWithUpHost:@"upload.qiniu.com" upHostBackup:@"up.qiniu.com" upIp:@"183.136.139.10" upIp2:@"115.231.182.136"];
	});
	return z0;
}

+ (instancetype)zone1 {
	static QNZone *z1 = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		z1 = [[self alloc] initWithUpHost:@"upload-z1.qiniu.com" upHostBackup:@"up-z1.qiniu.com" upIp:@"106.38.227.28" upIp2:@"106.38.227.27"];
	});
	return z1;
}

@end
