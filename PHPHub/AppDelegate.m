//
//  AppDelegate.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "AppDelegate.h"
#import "NSURL+QueryDictionary.h"

#import "UMFeedback.h"
#import "UMOpus.h"
#import "UMengSocialHandler.h"
#import "JpushHandler.h"
#import "LaunchScreenAdHandler.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // About feedback
    [UMFeedback setAppkey:UMENG_APPKEY];
    [UMOpus setAudioEnable:YES];
    
    // Showing the App
    [self makeWindowVisible:launchOptions];
    
    // Change UITextField and UITextView Cursor / Caret Color
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [[UITextView appearance] setTintColor:[UIColor grayColor]];
    
    // UMeng Share
    [UMengSocialHandler setup];
    
    return YES;
}

- (void)makeWindowVisible:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    if (_tabBarViewController == nil){
        _tabBarViewController = [[BaseTabBarViewController alloc] init];
    }
    self.window.rootViewController = _tabBarViewController;
    
    [self.window makeKeyAndVisible];
    
    [JpushHandler sendUserIdToAlias];
    [JpushHandler setupJpush:nil];
    
    [LaunchScreenAdHandler showLaunchScreenAd];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Jpush
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // jpush
    [APService handleRemoteNotification:userInfo];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([url.scheme isEqualToString:@"phphub"]) {
        [self captureUrlScheme:url];
        return YES;
    }
    
    // Umeng URL Callback
    return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}

- (void)captureUrlScheme:(NSURL *)url {
    NSString *type = url.host;
    
    NSDictionary *params = [url uq_queryDictionary];
    
    NSNumber *objectId = 0;
    if([params objectForKey:@"id"] != nil) {
        objectId = params[@"id"];
    }
    
    if ([type isEqualToString:@"users"] && objectId.integerValue > 0) {
        [JumpToOtherVCHandler jumpToUserProfileWithUserId:objectId];
    } else if([type isEqualToString:@"topics"] && objectId.integerValue > 0) {
        [JumpToOtherVCHandler jumpToTopicDetailWithTopicId:objectId];
    }
}

#pragma mark - Status bar touch tracking
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    if (CGRectContainsPoint(statusBarFrame, location)) {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:DidTapStatusBar object:nil];
}
@end
