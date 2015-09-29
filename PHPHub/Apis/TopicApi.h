//
//  TopicApi.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseApi.h"
#import "TopicEntity.h"

@interface TopicApi : BaseApi
- (id)getAll:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getNewestTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getHotsTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getNoReplyTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getJobTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getWiKiList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
@end
