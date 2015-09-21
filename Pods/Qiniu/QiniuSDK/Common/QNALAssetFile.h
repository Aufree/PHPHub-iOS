//
//  QNALAssetFile.h
//  QiniuSDK
//
//  Created by bailong on 15/7/25.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QNFileDelegate.h"

#if defined(__IPHONE_OS_VERSION_MAX_ALLOWED)
@class ALAsset;
@interface QNALAssetFile : NSObject <QNFileDelegate>

/**
 *    打开指定文件
 *
 *    @param path      文件路径
 *    @param error     输出的错误信息
 *
 *    @return 实例
 */
- (instancetype)init:(ALAsset *)asset
               error:(NSError *__autoreleasing *)error;
@end
#endif