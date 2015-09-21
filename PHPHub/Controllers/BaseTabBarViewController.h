//
//  BaseTabBarViewController.h
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarViewController : UITabBarController <UITabBarControllerDelegate>
- (void)setupTabBarItems;
- (void)jumpToViewController:(UIViewController *)viewController;
- (void)jumpToViewControllerWithAnimation:(UIViewController *)viewController;
@end
