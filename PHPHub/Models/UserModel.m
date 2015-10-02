//
//  UserModel.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "UserModel.h"

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
            }
        } else {
            if (block) block(nil, error);
        }
    };
    
    return [_api getCurrentUserData:callback];
}

- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block {
    return [_api loginWithUserName:username loginToken:loginToken block:block];
}

@end
