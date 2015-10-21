//
//  ExceptionHandler.m
//  PHPHub
//
//  Created by Aufree on 10/21/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "ExceptionHandler.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ExceptionHandler

+ (void)bootup {
    
    // Init Crashlitics
    [Fabric with:@[[Crashlytics class]]];
    
    if ([[CurrentUser Instance] isLogin]) {
        [CrashlyticsKit setUserIdentifier:[[CurrentUser Instance].userId stringValue]];
        [CrashlyticsKit setUserName:[[CurrentUser Instance] userInfo].username];
    }
}

+ (void)logEvent:(NSString *)eventName {
    [Answers logCustomEventWithName:eventName customAttributes:@{}];
}

+ (void)logEvent:(NSString *)eventName attributes:(NSDictionary * )attributes {
    [Answers logCustomEventWithName:eventName customAttributes:attributes];
}

+ (void)setObjectValue:(id)value forKey:(NSString *)key {
    [[Crashlytics sharedInstance] setObjectValue:value forKey:key];
}

+ (void)setIntValue:(int)value forKey:(NSString *)key {
    [[Crashlytics sharedInstance] setIntValue:value forKey:key];
}

+ (void)setBoolValue:(BOOL)value forKey:(NSString *)key {
    [[Crashlytics sharedInstance] setBoolValue:value forKey:key];
}

+ (void)setFloatValue:(float)value forKey:(NSString *)key {
    [[Crashlytics sharedInstance] setFloatValue:value forKey:key];
}

@end
