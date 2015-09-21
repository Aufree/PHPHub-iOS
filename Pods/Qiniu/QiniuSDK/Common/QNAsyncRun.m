//
//  QNAsyncRun.m
//  QiniuSDK
//
//  Created by bailong on 14/10/17.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNAsyncRun.h"

void QNAsyncRun(QNRun run) {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
		run();
	});
}

void QNAsyncRunInMain(QNRun run) {
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		run();
	});
}
