//
//  NotificationListCell.h
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotificationEntity.h"

@interface NotificationListCell : UITableViewCell
@property (nonatomic, strong) NotificationEntity *notificationEntity;
+ (CGFloat)countHeightForCell:(NotificationEntity *)notificationEntity;
@end
