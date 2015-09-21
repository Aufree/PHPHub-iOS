//
//  QNCrc.h
//  QiniuSDK
//
//  Created by bailong on 14-9-29.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    生成crc32 校验码
 */
@interface QNCrc32 : NSObject

/**
 *    文件校验
 *
 *    @param filePath 文件路径
 *    @param error    文件读取错误
 *
 *    @return 校验码
 */
+ (UInt32)file:(NSString *)filePath
         error:(NSError **)error;

/**
 *    二进制字节校验
 *
 *    @param data 二进制数据
 *
 *    @return 校验码
 */
+ (UInt32)data:(NSData *)data;

@end
