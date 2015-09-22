//
//  TopicEntity.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

@interface TopicEntity : BaseEntity
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, strong) NSNumber *topicRepliesCount;
@end
