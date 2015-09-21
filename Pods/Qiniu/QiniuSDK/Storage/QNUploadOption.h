//
//  QNUploadOption.h
//  QiniuSDK
//
//  Created by bailong on 14/10/4.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    上传进度回调函数
 *
 *    @param key     上传时指定的存储key
 *    @param percent 进度百分比
 */
typedef void (^QNUpProgressHandler)(NSString *key, float percent);

/**
 *    上传中途取消函数
 *
 *    @return 如果想取消，返回True, 否则返回No
 */
typedef BOOL (^QNUpCancellationSignal)(void);

/**
 *    可选参数集合，此类初始化后sdk上传使用时 不会对此进行改变；如果参数没有变化以及没有使用依赖，可以重复使用。
 */
@interface QNUploadOption : NSObject

/**
 *    用于服务器上传回调通知的自定义参数，参数的key必须以x: 开头
 */
@property (copy, nonatomic, readonly) NSDictionary *params;

/**
 *    指定文件的mime类型
 */
@property (copy, nonatomic, readonly) NSString *mimeType;

/**
 *    是否进行crc校验
 */
@property (readonly) BOOL checkCrc;

/**
 *    进度回调函数
 */
@property (copy, readonly) QNUpProgressHandler progressHandler;

/**
 *    中途取消函数
 */
@property (copy, readonly) QNUpCancellationSignal cancellationSignal;

/**
 *    可选参数的初始化方法
 *
 *    @param mimeType     mime类型
 *    @param progress     进度函数
 *    @param params       自定义服务器回调参数
 *    @param check        是否进行crc检查
 *    @param cancellation 中途取消函数
 *
 *    @return 可选参数类实例
 */
- (instancetype)initWithMime:(NSString *)mimeType
             progressHandler:(QNUpProgressHandler)progress
                      params:(NSDictionary *)params
                    checkCrc:(BOOL)check
          cancellationSignal:(QNUpCancellationSignal)cancellation;

- (instancetype)initWithProgessHandler:(QNUpProgressHandler)progress;

/**
 *    内部使用，默认的参数实例
 *
 *    @return 可选参数类实例
 */
+ (instancetype)defaultOptions;

@end
