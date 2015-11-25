//
//  UserDBManager.m
//  PHPHub
//
//  Created by Aufree on 10/2/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "UserDBManager.h"

@implementation UserDBManager

+ (UserEntity *)findByUserId:(NSNumber *)userId {
    UserEntity *tmpEntity = [[UserEntity alloc] init];
    tmpEntity.userId = userId;
    return [UserDBManager findUsingPrimaryKeys:tmpEntity];
}

@end
