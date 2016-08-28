//
//  CategoryModel.m
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _api = [[CategoryApi alloc] init];
    }
    return self;
}

- (id)getAllTopicCategory:(BaseResultBlock)block {
    return [_api getAllTopicCategory:block];
}
@end
