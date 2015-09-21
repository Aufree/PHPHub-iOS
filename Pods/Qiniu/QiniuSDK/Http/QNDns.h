//
//  QNDns.h
//  QiniuSDK
//
//  Created by bailong on 15/1/2.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QNDns : NSObject

+ (NSArray *)getAddresses:(NSString *)hostName;

+ (NSString *)getAddressesString:(NSString *)hostName;

+ (NSString *)getAddress:(NSString *)hostName;

@end
