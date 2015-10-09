//
//  TopicEntity.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicEntity.h"

@implementation TopicEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"topicId" : @"id",
             @"topicTitle" : @"title",
             @"topicRepliesCount" : @"reply_count",
             @"voteCount" : @"vote_count",
             @"user" : @"user.data",
             @"lastReplyUser" : @"last_reply_user.data",
             @"node" : @"node.data",
             @"topicContentUrl" : @"links.details_web_view",
             @"topicRepliesUrl" : @"links.replies_web_view",
             @"favorite" : @"favorite",
             @"attention" : @"attention",
             @"updatedAt" : @"updated_at",
             };
}

+ (NSValueTransformer *)userJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserEntity class]];
}

+ (NSValueTransformer *)lastReplyUserJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[UserEntity class]];
}

+ (NSValueTransformer *)nodeJSONTransformer
{
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[NodeEntity class]];
}
@end
