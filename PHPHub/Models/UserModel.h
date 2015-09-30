//
//  UserModel.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseModel.h"
#import "UserApi.h"

@interface UserModel : BaseModel
@property (nonatomic, strong) UserApi *api;
- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block;
@end
