//
//  NodeModel.h
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseModel.h"
#import "NodeApi.h"

@interface NodeModel : BaseModel
@property (nonatomic, strong) NodeApi *api;
- (id)getAllTopicNode:(BaseResultBlock)block;
@end
