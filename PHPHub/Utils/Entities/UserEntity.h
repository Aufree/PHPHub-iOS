//
//  UserEntity.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

@interface UserEntity : BaseEntity
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *githubId;
@property (nonatomic, copy) NSString *githubURL;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatar;
@end
