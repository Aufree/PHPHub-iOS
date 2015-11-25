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
#import "ExceptionHandler.h"
#import "SSKeychain.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Application delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Showing the App
    [self makeWindowVisible:launchOptions];
    
    // Basic setup
    [self basicSetup];

    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [LaunchScreenAdHandler checkShouldShowLaunchScreenAd];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[CurrentUser Instance] checkNoticeCount];
}

#pragma mark - Make window visible

- (void)makeWindowVisible:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
    if (_tabBarViewController == nil){
        _tabBarViewController = [[BaseTabBarViewController alloc] init];
    }
    self.window.rootViewController = _tabBarViewController;
    
    [self.window makeKeyAndVisible];
}

#pragma mark - Basic setup

- (void)basicSetup {
    // About feedback
    [UMFeedback setAppkey:UMENG_APPKEY];
    [UMOpus setAudioEnable:YES];
    
    // Exception Collection
    [ExceptionHandler bootup];
    
    // Change UITextField and UITextView Cursor / Caret Color
    [[UITextField appearance] setTintColor:[UIColor grayColor]];
    [[UITextView appearance] setTintColor:[UIColor grayColor]];
    
    // UMeng Share
    [UMengSocialHandler setup];
    
    // Tracking Server Bootup
    [AnalyticsHandler bootup];
    
    // Setup Jpush
    [JpushHandler sendUserIdToAlias];
    [JpushHandler setupJpush:nil];
    
    // Show launch screen ad
    if ([GVUserDefaults standardUserDefaults].userClientToken) {
        [LaunchScreenAdHandler showLaunchScreenAd];
    }
    
    // Update current user info
    [[CurrentUser Instance] updateCurrentUserInfoIfNeeded];
    
    // SVProgressHUD customized
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    
    // Setup SSKeyChain
    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];
}

#pragma mark - APNs

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Jpush
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // jpush
    [APService handleRemoteNotification:userInfo];
    
    if (userInfo && application.applicationState == UIApplicationStateInactive) {
        [JpushHandler handleUserInfo:userInfo];
    }
}

#pragma mark - Handle url scheme

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
