//
//  QNFileRecorder.h
//  QiniuSDK
//
//  Created by bailong on 14/10/5.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNRecorderDelegate.h"

/**
 *    将上传记录保存到文件系统中
 */
@interface QNFileRecorder : NSObject <QNRecorderDelegate>

/**
 *    用指定保存的目录进行初始化
 *
 *    @param directory 目录
 *    @param error     输出的错误信息
 *
 *    @return 实例
 */
+ (instancetype)fileRecorderWithFolder:(NSString *)directory
                                 error:(NSError *__autoreleasing *)error;

/**
 *    用指定保存的目录，以及是否进行base64编码进行初始化，
 *
 *    @param directory 目录
 *    @param encode    为避免因为特殊字符或含有/，无法保存持久化记录，故用此参数指定是否要base64编码
 *    @param error     输出错误信息
 *
 *    @return 实例
 */
+ (instancetype)fileRecorderWithFolder:(NSString *)directory
                             encodeKey:(BOOL)encode
                                 error:(NSError *__autoreleasing *)error;

/**
 *    从外部手动删除记录，如无特殊需求，不建议使用
 *
 *    @param key    持久化记录key
 *    @param dir    目录
 *    @param encode 是否encode
 */
+ (void)removeKey:(NSString *)key
        directory:(NSString *)dir
        encodeKey:(BOOL)encode;


@end
