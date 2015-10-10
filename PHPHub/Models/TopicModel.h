//
//  TopicModel.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseModel.h"
#import "TopicApi.h"

@interface TopicModel : BaseModel
@property TopicApi *api;
- (id)getAllTopic:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getExcellentTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getNewestTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getHotsTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getNoReplyTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getJobTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getWiKiList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getFavoriteTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getAttentionTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getTopicById:(NSInteger)topicId callback:(BaseResultBlock)block;
- (id)addCommentToTopic:(CommentEntity *)comment withBlock:(BaseResultBlock)block;
- (id)favoriteTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block;
- (id)cancelFavoriteTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block;
- (id)attentionTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block;
- (id)cancelAttentionTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block;
- (id)createTopic:(TopicEntity *)entity withBlock:(BaseResultBlock)block;
- (id)voteUpTopic:(NSNumber *)topicId withBlock:(BaseResultBlock)block;
- (id)voteDownTopic:(NSNumber *)topicId withBlock:(BaseResultBlock)block;
@end