//
//  JpushHandler.m
//  PHPHub
//
//  Created by Aufree on 10/16/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "JpushHandler.h"

@implementation JpushHandler
+ (void)setupJpush:(NSDictionary *)launchOptions {
    // Required
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    
    // Required
    [APService setupWithOption:launchOptions];
    
    [self sendTagsAndAlias];
    [self sendUserIdToAlias];
}

// 提交后的结果回调, 见 http://docs.jpush.cn/pages/viewpage.action?pageId=3309913
+ (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSString *callbackString = [NSString stringWithFormat:@"Result: %d, \ntags: %@, \nalias: %@\n", iResCode, [JpushHandler logSet:tags], alias];
    
    // 提交成功
    if (iResCode == 0)
    {
        NSString *build = [[NSUserDefaults standardUserDefaults] objectForKey:@"tmpLastBuildNumberIndentifier"];
        
        [[NSUserDefaults standardUserDefaults] setObject:build forKey:@"LastBuildNumberIndentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    NSLog(@"JPUSH TagsAlias 回调: %@", callbackString);
}

// log NSSet with UTF8
// if not ,log will be \Uxxx
+ (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) return nil;
    
    NSString *tempStr1 = [[dic description] stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData   = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
    return str;
}

+ (void)sendTagsAndAlias {
    NSString *lastBuildNumher = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastBuildNumberIndentifier"];
    
    if ([CurrentUser Instance].isLogin) {
        // Build Number
        NSString * build = [NSString stringWithFormat:@"ios_build_%@", [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey]];
        
        // 没有发送过, 或者 Build 不一样了, 才发送
        if (![build isEqualToString:lastBuildNumher]) {
            NSMutableSet *tags = [NSMutableSet set];
            
            // Detail Version
            NSString *version = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
            NSString *fullVersionNum = [NSString stringWithFormat:@"ios_v_%@", [version stringByReplacingOccurrencesOfString:@"." withString:@"_"]];
            
            // Big Version
            NSArray *verisonArray = [version componentsSeparatedByString:@"."];
            NSString *bigVersionNum = [NSString stringWithFormat:@"ios_v_%@", verisonArray[0]];
            
            [tags addObject:fullVersionNum];
            [tags addObject:bigVersionNum];
            [tags addObject:build];
            
            [APService setTags:tags
                         alias:[NSString stringWithFormat:@"userid_%@", [CurrentUser Instance].userId]
              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                        target:self];
            
            [[NSUserDefaults standardUserDefaults] setObject:build forKey:@"tmpLastBuildNumberIndentifier"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
}

+ (void)sendUserIdToAlias {
    if ([[CurrentUser Instance] isLogin]) {
        [APService setAlias:[NSString stringWithFormat:@"userid_%@", [CurrentUser Instance].userId] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}

+ (void)sendEmptyAlias {
    [APService setAlias:@"" callbackSelector:nil object:self];
}

+ (void)handleUserInfo:(NSDictionary *)userInfo {
    if (userInfo[@"reply_id"] && userInfo[@"replies_url"]) {
        [JumpToOtherVCHandler jumpToWebVCWithUrlString:userInfo[@"replies_url"]];
    } else if (userInfo[@"topic_id"]) {
        [JumpToOtherVCHandler jumpToTopicDetailWithTopicId:userInfo[@"topic_id"]];
    }
}

@end
