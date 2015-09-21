//
//  QNRecord.h
//  HappyDNS
//
//  Created by bailong on 15/6/23.
//  Copyright (c) 2015年 Qiniu Cloud Storage. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    A 记录
 */
extern const int kQNTypeA;

/**
 *  Cname 记录
 */
extern const int kQNTypeCname;


@interface QNRecord : NSObject
@property (nonatomic, readonly) NSString *value;
@property (readonly) int ttl;
@property (readonly) int type;
@property (readonly) long long timeStamp;

- (instancetype)init:(NSString *)value
        ttl:(int)ttl
        type:(int)type;

- (BOOL)expired:(long long)time;
@end
