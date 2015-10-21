//
//  AnalyticsHandler.h
//  PHPHub
//
//  Created by Aufree on 10/21/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kShare       @"用户分享"
#define kUserAction  @"用户行为"
#define kTopicAction @"帖子操作"

@interface AnalyticsHandler : NSObject
+ (void)bootup;
+ (void)logEvent:(NSString *)event;
+ (void)logEvent:(NSString *)event withProperties:(NSDictionary *)dict;
+ (void)logEvent:(NSString *)event withCategory:(NSString *)category label:(NSString *)lable;
+ (void)logScreen:(NSString *)screenName;

// Log Time
+ (void)startTimeEvent:(NSString *)event;
+ (void)endTimedEventForHttp:(NSString *)event;
+ (void)endTimedEventForDatabase:(NSString *)event;
+ (void)endTimedEvent:(NSString *)event withCategory:(NSString *)category label:(NSString *)label;
@end
