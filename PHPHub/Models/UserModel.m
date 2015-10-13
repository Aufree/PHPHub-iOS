//
//  UserModel.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "UserModel.h"
#import "AccessTokenHandler.h"

@implementation UserModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _api = [[UserApi alloc] init];
    }
    return self;
}

- (id)getCurrentUserData:(BaseResultBlock)block {
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (data) {
            UserEntity *user = data[@"entity"];
            if (user) {
                [[CurrentUser Instance] saveUser:user];
                [GVUserDefaults standardUserDefaults].currentUserId = user.userId;
            }
            if (block) block(data, nil);
        } else {
            if (block) block(nil, error);
        }
    };
    
    return [_api getCurrentUserData:callback];
}

- (id)getUserById:(NSNumber *)userId callback:(BaseResultBlock)block {
    return [_api getUserById:userId callback:block];
}

- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block {
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (data) {
            [self completeLoginAction:data];
            [self getCurrentUserData:^(NSDictionary *userdata, NSError *error) {
                if (block) block(data, nil);
            }];
        } else {
            if (block) block(nil, error);
        }
    };
    
    return [_api loginWithUserName:username loginToken:loginToken block:callback];
}

- (void)completeLoginAction:(NSDictionary *)data {
    [AccessTokenHandler storeLoginTokenGrantAccessToken:data[@"access_token"]];
    [[BaseApi loginTokenGrantInstance] setUpLoginTokenGrantRequest];
    [[CurrentUser Instance] setupClientRequestState:nil];
}

- (id)updateUserProfile:(UserEntity *)user withBlock:(BaseResultBlock)block {
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (data) {
            UserEntity *userEntity = data[@"entity"];
            [[CurrentUser Instance] saveUser:userEntity];
            if (block) block(data, nil);
        } else {
            if (block) block(nil, error);
        }
    };
    return [_api updateUserProfile:user withBlock:callback];
}
@end
