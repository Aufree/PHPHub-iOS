//
//  AdModel.m
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "AdModel.h"

@implementation AdModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _api = [[AdApi alloc] init];
    }
    return self;
}

- (id)getAdvertsLaunchScreen:(BaseResultBlock)block {
    return [_api getAdvertsLaunchScreen:block];
}

@end
