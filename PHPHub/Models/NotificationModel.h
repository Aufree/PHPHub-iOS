//
//  NotificationModel.h
//  PHPHub
//
//  Created by Aufree on 10/13/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseModel.h"
#import "NotificationApi.h"

@interface NotificationModel : BaseModel
@property (nonatomic, strong) NotificationApi *api;
- (id)getNotificationList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
- (id)getUnreadNotificationCount:(BaseResultBlock)block;
@end
