//
//  NodeModel.m
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "NodeModel.h"

@implementation NodeModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _api = [[NodeApi alloc] init];
    }
    return self;
}

- (id)getAllTopicNode:(BaseResultBlock)block {
    return [_api getAllTopicNode:block];
}
@end
