//
//  NotificationModel.m
//  PHPHub
//
//  Created by Aufree on 10/13/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "NotificationModel.h"

@implementation NotificationModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        _api = [[NotificationApi alloc] init];
    }
    return self;
}

- (id)getNotificationList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    return [_api getNotificationList:block atPage:pageIndex];
}
@end
