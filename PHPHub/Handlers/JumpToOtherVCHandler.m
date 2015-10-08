//
//  JumpToOtherVCHandler.m
//  PHPHub
//
//  Created by Aufree on 10/8/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "JumpToOtherVCHandler.h"
#import "BaseTabBarViewController.h"
#import "AppDelegate.h"

@implementation JumpToOtherVCHandler
+ (void)pushToOtherView:(UIViewController *)vc animated:(BOOL)animated {
    BaseTabBarViewController *tabbar = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarViewController];
    [tabbar pushToViewController:vc animated:YES];
}

+ (void)presentToOtherView:(UIViewController *)vc animated:(BOOL)animated completion:(void (^ __nullable)(void))completion {
    BaseTabBarViewController *tabbar = [(AppDelegate *)[[UIApplication sharedApplication] delegate] tabBarViewController];
    [tabbar presentViewController:vc animated:animated completion:completion];
}
@end
