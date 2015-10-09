//
//  CommentEntity.h
//  PHPHub
//
//  Created by Aufree on 10/9/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

@interface CommentEntity : BaseEntity
@property (nonatomic, copy) NSNumber *commentId;
@property (nonatomic, copy) NSNumber *topicId;
@property (nonatomic, copy) NSString *commentBody;
@end
