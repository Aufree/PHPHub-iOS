//
//  NodeApi.h
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseApi.h"
#import "NodeEntity.h"

@interface NodeApi : BaseApi
- (id)getAllTopicNode:(BaseResultBlock)block;
@end
