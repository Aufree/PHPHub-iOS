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
@end
