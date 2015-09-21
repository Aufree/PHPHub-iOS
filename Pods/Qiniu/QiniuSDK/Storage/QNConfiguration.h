//
//  QNConfiguration.h
//  QiniuSDK
//
//  Created by bailong on 15/5/21.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNRecorderDelegate.h"

#import "HappyDNS.h"

/**
 *    断点上传时的分块大小
 */
extern const UInt32 kQNBlockSize;

/**
 *    转换为用户需要的url
 *
 *    @param url  上传url
 *
 *    @return 根据上传url算出代理url
 */
typedef NSString *(^QNUrlConvert)(NSString *url);

@class QNConfigurationBuilder;

/**
 *    Builder block
 *
 *    @param builder builder实例
 */
typedef void (^QNConfigurationBuilderBlock)(QNConfigurationBuilder *builder);


@interface QNConfiguration : NSObject

/**
 *    默认上传服务器地址
 */
@property (copy, nonatomic, readonly) NSString *upHost;

/**
 *    备用上传服务器地址
 */
@property (copy, nonatomic, readonly) NSString *upHostBackup;

/**
 *    备用上传IP
 */
@property (copy, nonatomic, readonly) NSString *upIp;

/**
 *    上传端口
 */
@property (nonatomic, readonly) UInt32 upPort;

/**
 *    断点上传时的分片大小
 */
@property (readonly) UInt32 chunkSize;

/**
 *    如果大于此值就使用断点上传，否则使用form上传
 */
@property (readonly) UInt32 putThreshold;

/**
 *    上传失败的重试次数
 */
@property (readonly) UInt32 retryMax;

/**
 *    超时时间 单位 秒
 */
@property (readonly) UInt32 timeoutInterval;

@property (nonatomic, readonly) id <QNRecorderDelegate> recorder;

@property (nonatomic, readonly) QNRecorderKeyGenerator recorderKeyGen;

@property (nonatomic, readonly)  NSDictionary *proxy;

@property (nonatomic, readonly) QNUrlConvert converter;

@property (nonatomic, readonly) QNDnsManager *dns;

+ (instancetype)build:(QNConfigurationBuilderBlock)block;

@end


@interface QNZone : NSObject

/**
 *    默认上传服务器地址
 */
@property (nonatomic, readonly) NSString *upHost;

/**
 *    备用上传服务器地址
 */
@property (nonatomic, readonly) NSString *upHostBackup;

/**
 *    备用上传IP
 */
@property (nonatomic, readonly) NSString *upIp;

/**
 *    备用上传IP
 */
@property (nonatomic, readonly) NSString *upIp2;

/**
 *    Zone初始化方法
 *
 *    @param upHost     默认上传服务器地址
 *    @param upHostBackup     备用上传服务器地址
 *    @param upIp       备用上传IP
 *
 *    @return Zone实例
 */
- (instancetype)initWithUpHost:(NSString *)upHost
                  upHostBackup:(NSString *)upHostBackup
                          upIp:(NSString *)upIp
                         upIp2:(NSString*)upIp2;

/**
 *    zone 0
 *
 *    @return 实例
 */
+ (instancetype)zone0;

/**
 *    zone 1
 *
 *    @return 实例
 */
+ (instancetype)zone1;

@end

@interface QNConfigurationBuilder : NSObject

/**
 *    默认上传服务器地址
 */
@property (nonatomic, strong) QNZone *zone;

/**
 *    上传端口
 */
@property (nonatomic, readonly) UInt32 upPort;

/**
 *    断点上传时的分片大小
 */
@property (assign) UInt32 chunkSize;

/**
 *    如果大于此值就使用断点上传，否则使用form上传
 */
@property (assign) UInt32 putThreshold;

/**
 *    上传失败的重试次数
 */
@property (assign) UInt32 retryMax;

/**
 *    超时时间 单位 秒
 */
@property (assign) UInt32 timeoutInterval;

@property (nonatomic, assign) id <QNRecorderDelegate> recorder;

@property (nonatomic, assign) QNRecorderKeyGenerator recorderKeyGen;

@property (nonatomic, assign)  NSDictionary *proxy;

@property (nonatomic, assign) QNUrlConvert converter;

@property (nonatomic, assign) QNDnsManager *dns;

@end
