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
- (id)all:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
@end
