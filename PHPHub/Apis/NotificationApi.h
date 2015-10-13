//
//  NotificationApi.h
//  PHPHub
//
//  Created by Aufree on 10/13/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseApi.h"
#import "NotificationEntity.h"

@interface NotificationApi : BaseApi
- (id)getNotificationList:(BaseResultBlock)block atPage:(NSInteger)pageIndex;
@end
