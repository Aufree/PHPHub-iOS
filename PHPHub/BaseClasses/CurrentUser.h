//
//  CurrentUser.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
#import "UserDBManager.h"

@interface CurrentUser : NSObject
+ (CurrentUser *)Instance;
- (void)saveUser:(UserEntity *)user;
- (void)setupClientRequestState;
@end
