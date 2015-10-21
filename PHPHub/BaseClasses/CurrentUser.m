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

- (void)saveUser:(UserEntity *)user {
    [UserDBManager insertOnDuplicateUpdate:user];
    [JpushHandler sendUserIdToAlias];
}

- (void)updateCurrentUserInfo {
    [[UserModel Instance] getCurrentUserData:nil];
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

- (void)logOut {
    [GVUserDefaults standardUserDefaults].userLoginToken = nil;
    [GVUserDefaults standardUserDefaults].currentUserId = nil;
    [JpushHandler sendEmptyAlias];
}

- (NSString *)userLabel {
    return self.isLogin ? [NSString stringWithFormat:@"user_%@_%@", [CurrentUser Instance].userId, [[CurrentUser Instance] userInfo].username] : @"non-logged-in";
}
@end
