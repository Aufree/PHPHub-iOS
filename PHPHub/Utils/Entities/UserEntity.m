//
//  UserEntity.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"userId" : @"id",
             @"githubId" : @"github_id",
             @"githubURL" : @"github_url",
             @"username" : @"name",
             @"avatar" : @"avatar",
             };
}

@end
