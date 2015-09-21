//
//  QNFormUpload.h
//  QiniuSDK
//
//  Created by bailong on 15/1/4.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUploadManager.h"
#import "QNhttpDelegate.h"
#import "QNUpToken.h"

@class QNHttpManager;
@interface QNFormUpload : NSObject

- (instancetype) initWithData:(NSData *)data
                      withKey:(NSString *)key
                    withToken:(QNUpToken *)token
        withCompletionHandler:(QNUpCompletionHandler)block
                   withOption:(QNUploadOption *)option
              withHttpManager:(id <QNHttpDelegate> )http
            withConfiguration:(QNConfiguration *)config;

- (void)put;


@end
