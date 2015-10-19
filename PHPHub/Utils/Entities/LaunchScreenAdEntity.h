//
//  LaunchScreenAdEntity.h
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

typedef NS_ENUM(NSInteger, LaunchScreenType) {
    LaunchScreenTypeByTopic = 0,
    LaunchScreenTypeByUser = 1,
    LaunchScreenTypeByWeb = 2,
    LaunchScreenTypeUnknow = 3,
};

@interface LaunchScreenAdEntity : BaseEntity <MTLFMDBSerializing>
@property (nonatomic, copy) NSNumber *launchScreenAdId;
@property (nonatomic, copy) NSString *launchDescription;
@property (nonatomic, copy) NSString *smallImage;
@property (nonatomic, copy) NSString *bigImage;
@property (nonatomic, assign) LaunchScreenType type;
@property (nonatomic, strong) NSString *launchScreenType;
@property (nonatomic, copy) NSString *payload;
@property (nonatomic, strong) NSDate *startAt;
@property (nonatomic, strong) NSDate *expiresAt;
@property (nonatomic, copy) NSNumber *displayTime;
@end
