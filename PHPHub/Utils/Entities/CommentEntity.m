//
//  CommentEntity.m
//  PHPHub
//
//  Created by Aufree on 10/9/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "CommentEntity.h"


@implementation CommentEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"commentId" : @"id",
             @"topicId" : @"topic_id",
             @"userId" : @"user_id",
             @"commentBody" : @"body",
             };
}

@end
