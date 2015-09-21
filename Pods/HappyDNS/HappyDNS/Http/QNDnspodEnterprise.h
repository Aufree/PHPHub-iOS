//
//  QNDnspodEnterprise.h
//  HappyDNS
//
//  Created by bailong on 15/7/31.
//  Copyright (c) 2015年 Qiniu Cloud Storage. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QNResolverDelegate.h"

extern const int kQN_ENCRYPT_FAILED;
extern const int kQN_DECRYPT_FAILED;

@interface QNDnspodEnterprise : NSObject <QNResolverDelegate>
@property (readonly, strong) NSString *server;

- (instancetype)initWithId:(NSString*)userId
        key:(NSString*)key;

- (instancetype)initWithId:(NSString*)userId
        key:(NSString*)key
        server:(NSString*)server;


- (NSArray *)query:(QNDomain *)domain networkInfo:(QNNetworkInfo *)netInfo error:(NSError *__autoreleasing *)error;
@end
