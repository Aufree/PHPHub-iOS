//
//  NotificationEntity.h
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

@interface NotificationEntity : BaseEntity
@property (nonatomic, strong) NSNumber *notificationId;
@property (nonatomic, copy) NSString *notificationContent;
@end
