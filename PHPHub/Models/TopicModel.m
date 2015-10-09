//
//  TopicModel.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _api = [[TopicApi alloc] init];
    }
    return self;
}

- (id)getAllTopic:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    return [_api getAll:block atPage:pageIndex];
}

- (id)getExcellentTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getExcellentTopicList:block atPage:pageIndex];
}

- (id)getNewestTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getNewestTopicList:block atPage:pageIndex];
}

- (id)getHotsTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getHotsTopicList:block atPage:pageIndex];
}

- (id)getNoReplyTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getNoReplyTopicList:block atPage:pageIndex];
}

- (id)getJobTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getJobTopicList:block atPage:pageIndex];
}

- (id)getWiKiList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getWiKiList:block atPage:pageIndex];
}

- (id)getTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getTopicListByUser:userId callback:block atPage:pageIndex];
}

- (id)getFavoriteTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getFavoriteTopicListByUser:userId callback:block atPage:pageIndex];
}

- (id)getAttentionTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getAttentionTopicListByUser:userId callback:block atPage:pageIndex];
}

- (id)getTopicById:(NSInteger)topicId callback:(BaseResultBlock)block {
    return [_api getTopicById:topicId callback:block];
}

- (id)addCommentToTopic:(CommentEntity *)comment withBlock:(BaseResultBlock)block {
    return [_api addCommentToTopic:comment withBlock:block];
}
@end
