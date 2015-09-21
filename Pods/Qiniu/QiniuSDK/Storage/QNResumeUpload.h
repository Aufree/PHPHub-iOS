//
//  QNResumeUpload.h
//  QiniuSDK
//
//  Created by bailong on 14/10/1.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNUploadManager.h"
#import "QNhttpDelegate.h"
#import "QNUpToken.h"
#import "QNFileDelegate.h"

@class QNHttpManager;
@interface QNResumeUpload : NSObject

- (instancetype) initWithFile:(id <QNFileDelegate> )file
                      withKey:(NSString *)key
                    withToken:(QNUpToken *)token
        withCompletionHandler:(QNUpCompletionHandler)block
                   withOption:(QNUploadOption *)option
                 withRecorder:(id <QNRecorderDelegate> )recorder
              withRecorderKey:(NSString *)recorderKey
              withHttpManager:(id <QNHttpDelegate> )http
            withConfiguration:(QNConfiguration *)config;

- (void)run;

@end
