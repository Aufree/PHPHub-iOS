//
//  TopicModel.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicModel.h"

@implementation TopicModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _api = [[TopicApi alloc] init];
    }
    return self;
}

- (id)all:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
{
    return [_api getAll:block atPage:pageIndex];
}
@end
