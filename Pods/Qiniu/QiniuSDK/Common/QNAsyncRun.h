//
//  QNAsyncRun.h
//  QiniuSDK
//
//  Created by bailong on 14/10/17.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

typedef void (^QNRun)(void);

void QNAsyncRun(QNRun run);

void QNAsyncRunInMain(QNRun run);
