//
//  QNFileDelegate.h
//  QiniuSDK
//
//  Created by bailong on 15/7/25.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *    文件处理接口，支持ALAsset, NSFileHandle, NSData
 */
@protocol QNFileDelegate <NSObject>

/**
 *    从指定偏移读取数据
 *
 *    @param offset 偏移地址
 *    @param size   大小
 *
 *    @return 数据
 */
- (NSData *)read:(long)offset
            size:(long)size;

/**
 *    读取所有文件内容
 *
 *    @return 数据
 */
- (NSData *)readAll;

/**
 *    关闭文件
 *
 */
- (void)close;

/**
 *    文件路径
 *
 *    @return 文件路径
 */
- (NSString *)path;

/**
 *    文件修改时间
 *
 *    @return 修改时间
 */
- (int64_t)modifyTime;

/**
 *    文件大小
 *
 *    @return 文件大小
 */
- (int64_t)size;

@end
