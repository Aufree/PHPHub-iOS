//
//  UserApi.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseApi.h"
#import "UserEntity.h"

@interface UserApi : BaseApi
- (id)getCurrentUserData:(BaseResultBlock)block;
- (id)getUserById:(NSNumber *)userId callback:(BaseResultBlock)block;
- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block;
- (id)updateUserProfile:(UserEntity *)user withBlock:(BaseResultBlock)block;
@end
