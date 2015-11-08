//
//  CurrentUser.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "CurrentUser.h"
#import "AccessTokenHandler.h"
#import "JpushHandler.h"
#import "NotificationModel.h"
#import "SSKeychain.h"

@implementation CurrentUser
+ (CurrentUser *)Instance {
    static dispatch_once_t once;
    static CurrentUser *sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[CurrentUser alloc] init];
    });
    return sharedInstance;
}

- (BOOL)isLogin {
    return (self.userId && self.userId.intValue > 0);
}

- (BOOL)hasClientToken {
    return [NSString isStringEmpty:[GVUserDefaults standardUserDefaults].userClientToken];
}

- (void)saveUser:(UserEntity *)user {
    [UserDBManager insertOnDuplicateUpdate:user];
    [JpushHandler sendUserIdToAlias];
}

- (void)updateCurrentUserInfoIfNeeded {
    if ([[CurrentUser Instance] isLogin]) {
        [[UserModel Instance] getCurrentUserData:nil];
    }
}

- (NSNumber *)userId {
    return [GVUserDefaults standardUserDefaults].currentUserId;
}

- (UserEntity *)userInfo {
    if (!self.userId) return nil;
    
    return [UserDBManager findByUserId:self.userId];
}

- (void)setupClientRequestState:(BaseResultBlock)block {
    [AccessTokenHandler fetchClientGrantTokenWithRetryTimes:3 callback:block];
}

- (void)checkNoticeCount {
    if ([[CurrentUser Instance] isLogin]) {
        [[NotificationModel Instance] getUnreadNotificationCount:^(id data, NSError *error) {
            if (!error) {
                NSNumber *unreadCount = data[@"count"];
                [[UIApplication sharedApplication] setApplicationIconBadgeNumber:unreadCount.integerValue];
                [[NSNotificationCenter defaultCenter] postNotificationName:UpdateNoticeCount object:nil userInfo:@{@"unreadCount":unreadCount}];
            }
        }];
    }
}

- (void)logOut {
    [SSKeychain deletePasswordForService:KeyChainService account:KeyChainAccount];
    [GVUserDefaults standardUserDefaults].currentUserId = nil;
    [JpushHandler sendEmptyAlias];
}

- (NSString *)userLabel {
    return self.isLogin ? [NSString stringWithFormat:@"user_%@_%@", [CurrentUser Instance].userId, [[CurrentUser Instance] userInfo].username] : @"non-logged-in";
}
@end
