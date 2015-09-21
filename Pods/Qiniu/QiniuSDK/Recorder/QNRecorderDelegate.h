//
//  QNRecorderDelegate.h
//  QiniuSDK
//
//  Created by bailong on 14/10/5.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    为持久化上传记录，根据上传的key以及文件名 生成持久化的记录key
 *
 *    @param uploadKey 上传的key
 *    @param filePath  文件名
 *
 *    @return 根据uploadKey, filepath 算出的记录key
 */
typedef NSString *(^QNRecorderKeyGenerator)(NSString *uploadKey, NSString *filePath);


/**
 *    持久化记录接口，可以实现将记录持久化到文件，数据库等
 */
@protocol QNRecorderDelegate <NSObject>

/**
 *    保存记录
 *
 *    @param key   持久化记录的key
 *    @param value 持久化记录上传状态信息
 *
 *    @return 错误信息，成功为nil
 */
- (NSError *)set:(NSString *)key
            data:(NSData *)value;

/**
 *    取出保存的持久化上传状态信息
 *
 *    @param key 持久化记录key
 *
 *    @return 上传中间状态信息
 */
- (NSData *)get:(NSString *)key;

/**
 *    删除持久化记录，一般在上传成功后自动调用
 *
 *    @param key 持久化记录key
 *
 *    @return 错误信息，成功为nil
 */
- (NSError *)del:(NSString *)key;

@end
