//
//  QNUploader.h
//  QiniuSDK
//
//  Created by bailong on 14-9-28.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNRecorderDelegate.h"

@class QNResponseInfo;
@class QNUploadOption;
@class QNConfiguration;
@class ALAsset;
/**
 *    上传完成后的回调函数
 *
 *    @param info 上下文信息，包括状态码，错误值
 *    @param key  上传时指定的key，原样返回
 *    @param resp 上传成功会返回文件信息，失败为nil; 可以通过此值是否为nil 判断上传结果
 */
typedef void (^QNUpCompletionHandler)(QNResponseInfo *info, NSString *key, NSDictionary *resp);

/**
   管理上传的类，可以生成一次，持续使用，不必反复创建。
 */
@interface QNUploadManager : NSObject

/**
 *    默认构造方法，没有持久化记录
 *
 *    @return 上传管理类实例
 */
- (instancetype)init;

/**
 *    使用一个持久化的记录接口进行记录的构造方法
 *
 *    @param recorder 持久化记录接口实现
 *
 *    @return 上传管理类实例
 */
- (instancetype)initWithRecorder:(id <QNRecorderDelegate> )recorder;

/**
 *    使用持久化记录接口以及持久化key生成函数的构造方法，默认情况下使用上传存储的key, 如果key为nil或者有特殊字符比如/，建议使用自己的生成函数
 *
 *    @param recorder             持久化记录接口实现
 *    @param recorderKeyGenerator 持久化记录key生成函数
 *
 *    @return 上传管理类实例
 */
- (instancetype)initWithRecorder:(id <QNRecorderDelegate> )recorder
            recorderKeyGenerator:(QNRecorderKeyGenerator)recorderKeyGenerator;

/**
 *    使用配置信息生成上传实例
 *
 *    @param config           配置信息
 *
 *    @return 上传管理类实例
 */
- (instancetype)initWithConfiguration:(QNConfiguration *)config;


/**
 *    方便使用的单例方法
 *
 *    @param config           配置信息
 *
 *    @return 上传管理类实例
 */
+ (instancetype)sharedInstanceWithConfiguration:(QNConfiguration *)config;

/**
 *    直接上传数据
 *
 *    @param data              待上传的数据
 *    @param key               上传到云存储的key，为nil时表示是由七牛生成
 *    @param token             上传需要的token, 由服务器生成
 *    @param completionHandler 上传完成后的回调函数
 *    @param option            上传时传入的可选参数
 */
- (void) putData:(NSData *)data
             key:(NSString *)key
           token:(NSString *)token
        complete:(QNUpCompletionHandler)completionHandler
          option:(QNUploadOption *)option;

/**
 *    上传文件
 *
 *    @param filePath          文件路径
 *    @param key               上传到云存储的key，为nil时表示是由七牛生成
 *    @param token             上传需要的token, 由服务器生成
 *    @param completionHandler 上传完成后的回调函数
 *    @param option            上传时传入的可选参数
 */
- (void) putFile:(NSString *)filePath
             key:(NSString *)key
           token:(NSString *)token
        complete:(QNUpCompletionHandler)completionHandler
          option:(QNUploadOption *)option;

/**
 *    上传ALAsset文件
 *
 *    @param alasset           ALAsset文件
 *    @param key               上传到云存储的key，为nil时表示是由七牛生成
 *    @param token             上传需要的token, 由服务器生成
 *    @param completionHandler 上传完成后的回调函数
 *    @param option            上传时传入的可选参数
 */
- (void) putALAsset:(ALAsset *)asset
                key:(NSString *)key
              token:(NSString *)token
           complete:(QNUpCompletionHandler)completionHandler
             option:(QNUploadOption *)option;

@end
