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
             @"username" : @"name",
             @"avatar" : @"avatar",
             @"githubId" : @"github_id",
             @"githubURL" : @"github_url",
             @"topicCount" : @"topic_count",
             @"replyCount" : @"reply_count",
             @"notificationCount" : @"notification_count",
             @"twitterAccount" : @"twitter_account",
             @"blogURL" : @"personal_website",
             @"company" : @"company",
             @"city" : @"city",
             @"email" : @"email",
             @"signature" : @"signature",
             @"introduction" : @"introduction",
             @"githubName" : @"github_name",
             @"realName" : @"real_name",
             @"createdAt" : @"created_at.date",
             @"updatedAt" : @"updated_at.date",
             };
}

+ (NSArray *)FMDBPrimaryKeys
{
    return @[@"id"];
}

+ (NSString *)FMDBTableName {
    return @"users";
}

#pragma mark - MTLFMDBAdapter

+ (NSDictionary *)FMDBColumnsByPropertyKey
{
    return @{
             @"userId" : @"id",
             @"username" : @"name",
             @"avatar" : @"avatar",
             @"githubId" : @"github_id",
             @"githubURL" : @"github_url",
             @"topicCount" : @"topic_count",
             @"replyCount" : @"reply_count",
             @"notificationCount" : [NSNull null],
             @"twitterAccount" : @"twitter_account",
             @"blogURL" : @"personal_website",
             @"company" : @"company",
             @"city" : @"city",
             @"email" : @"email",
             @"signature" : @"signature",
             @"introduction" : @"introduction",
             @"githubName" : @"github_name",
             @"realName" : @"real_name",
             @"createdAt" : @"created_at",
             @"updatedAt" : @"updated_at",
             };
}
@end
