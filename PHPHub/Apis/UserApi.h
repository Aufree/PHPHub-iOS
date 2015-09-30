//
//  UserApi.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseApi.h"

@interface UserApi : BaseApi
- (id)loginWithUserName:(NSString *)username loginToken:(NSString *)loginToken block:(BaseResultBlock)block;
@end
