//
//  CurrentUser.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "CurrentUser.h"
#import "AccessTokenHandler.h"

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
    [AccessTokenHandler clearToken];
    self.userId = nil;
}
@end
