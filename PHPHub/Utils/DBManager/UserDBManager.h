//
//  UserDBManager.h
//  PHPHub
//
//  Created by Aufree on 10/2/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseDBManager.h"
#import "UserEntity.h"

@interface UserDBManager : BaseDBManager
+ (UserEntity *)findByUserId:(NSNumber *)userId;
@end