//
//  UMengSocialHandler.m
//  PHPHub
//
//  Created by Aufree on 10/15/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "UMengSocialHandler.h"

@implementation UMengSocialHandler

+ (void)setup {
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialQQHandler setQQWithAppId:UMENG_QQ_ID appKey:UMENG_QQ_APPKEY url:PHPHubUrl];
}

@end