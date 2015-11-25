//
//  UIResponder+Router.m
//  PHPHub
//
//  Created by zhengjinghua on 9/24/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}

@end
