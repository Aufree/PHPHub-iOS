//
//  AnalyticsHandler.m
//  PHPHub
//
//  Created by Aufree on 10/21/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "AnalyticsHandler.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"

@implementation AnalyticsHandler
static NSMutableDictionary *timedEvents;
static dispatch_queue_t timingQueue;

// Constants used to parsed dictionnary to match Google Analytics tracker properties
static NSString* const kCategory = @"Category";
static NSString* const kLabel = @"Label";
static NSString* const kAction = @"Action";
static NSString* const kValue = @"Value";

// Constants for timedEvents structure
static NSString* const kTime = @"time";
static NSString* const kProperties = @"properties";

+ (void)bootup {
    
    // Disable it on development envirment
#if !DEBUG
    // Common Setup
    [self enableHandleUncaughtExceptions:YES];
    [GAI sharedInstance].dispatchInterval = 30;
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:TRACKING_ID];
#endif
    
    timedEvents = [[NSMutableDictionary alloc] init];
    timingQueue = dispatch_queue_create("analyticsKit.goolgeAnalytics.provider", DISPATCH_QUEUE_SERIAL);
}


+ (void)uncaughtException:(NSException *)exception {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder
                    createExceptionWithDescription:[[exception userInfo] description]
                    withFatal:@(YES)] build]];
}

#pragma mark - Log Screen

+ (void)logScreen:(NSString *)screenName {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName
           value:screenName];
    
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

#pragma mark - Log Event

+ (void)logEvent:(NSString *)event {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:nil
                                                          action:event
                                                           label:nil
                                                           value:nil] build]];
}

+ (void)logEvent:(NSString *)event withCategory:(NSString *)category label:(NSString *)lable {
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:event
                                                           label:lable
                                                           value:nil] build]];
}

+ (void)logEvent:(NSString *)event withProperties:(NSDictionary *)dict {
    NSString *category = [self valueFromDictionnary:dict forKey:kCategory];
    NSString *label = [self valueFromDictionnary:dict forKey:kLabel];
    NSNumber *value = [self valueFromDictionnary:dict forKey:kValue];
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:event
                                                           label:label
                                                           value:value] build]];
}

#pragma mark - Log Event

+ (void)startTimeEvent:(NSString *)event {
    dispatch_sync(timingQueue, ^{
        timedEvents[event] = [NSDate date];
    });
}

+ (void)endTimedEventForHttp:(NSString *)event {
    [self endTimedEvent:event withCategory:@"网络请求" label:[[CurrentUser Instance] userLabel]];
}

+ (void)endTimedEventForDatabase:(NSString *)event {
    [self endTimedEvent:event withCategory:@"数据库操作" label:[[CurrentUser Instance] userLabel]];
}

+ (void)endTimedEvent:(NSString *)event withCategory:(NSString *)category label:(NSString *)label {
    NSDate* startDate = timedEvents[event];
    if (!startDate) return;
    
    __block NSTimeInterval time;
    dispatch_sync(timingQueue, ^{
        // calculating the elapsed time
        NSDate* endDate = [NSDate date];
        time = endDate.timeIntervalSince1970 - startDate.timeIntervalSince1970;
        // removed time which will be logged
        [timedEvents removeObjectForKey:event];
    });
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category
                                                         interval:@((int)(time * 1000))
                                                             name:event
                                                            label:label] build]];
}

#pragma mark - Log Error

+ (void)logError:(NSString *)name message:(NSString *)message exception:(NSException *)exception {
    id tracker = [[GAI sharedInstance] defaultTracker];
    // isFatal = NO, presume here, Exeption is not fatal.
    [tracker send:[[GAIDictionaryBuilder
                    createExceptionWithDescription:message
                    withFatal:@(NO)] build]];
    
}

+ (void)logError:(NSString *)name message:(NSString *)message error:(NSError *)error {
    id tracker = [[GAI sharedInstance] defaultTracker];
    // isFatal = NO, presume here, Exeption is not fatal.
    [tracker send:[[GAIDictionaryBuilder
                    createExceptionWithDescription:message
                    withFatal:@(NO)] build]];
}

#pragma mark - Extra methods

+ (void)enableDebug:(BOOL)enabled {
    [[GAI sharedInstance] setDryRun:enabled];
}

+ (void)enableHandleUncaughtExceptions:(BOOL)enabled {
    [GAI sharedInstance].trackUncaughtExceptions = enabled;
}

#pragma mark - Private methods

+ (id)valueFromDictionnary:(NSDictionary*)dictionnary forKey:(NSString*)key {
    if (dictionnary[key.lowercaseString]) {
        return dictionnary[key.lowercaseString];
    }
    
    if (dictionnary[key]) {
        return dictionnary[key];
    }
    return nil;
}

@end
