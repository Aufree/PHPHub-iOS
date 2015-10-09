//
//  TopicEntity.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"
#import "UserEntity.h"
#import "NodeEntity.h"

@interface TopicEntity : BaseEntity
@property (nonatomic, strong) NSNumber *topicId;
@property (nonatomic, copy) NSString *topicTitle;
@property (nonatomic, strong) NSNumber *topicRepliesCount;
@property (nonatomic, strong) NSNumber *voteCount;
@property (nonatomic, strong) UserEntity *user;
@property (nonatomic, strong) UserEntity *lastReplyUser;
@property (nonatomic, strong) NodeEntity *node;
@property (nonatomic, copy) NSString *topicContentUrl;
@property (nonatomic, copy) NSString *topicRepliesUrl;
@property (nonatomic, strong) NSDate *updatedAt;
@end
