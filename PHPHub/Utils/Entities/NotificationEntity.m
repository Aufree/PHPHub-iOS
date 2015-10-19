//
//  NotificationEntity.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationEntity.h"

@implementation NotificationEntity
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"notificationId" : @"id",
             @"message" : @"message",
             @"fromUser" : @"from_user.data",
             @"topic" : @"topic.data",
             @"createdAt" : @"created_at",
             };
}

+ (NSValueTransformer *)fromUserJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserEntity class]];
}

+ (NSValueTransformer *)topicJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[TopicEntity class]];
}
@end