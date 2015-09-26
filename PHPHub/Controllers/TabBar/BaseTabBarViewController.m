//
//  BaseTabBarViewController.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseTabBarViewController.h"
#import "EssentialListViewController.h"
#import "TopicListContainerViewController.h"
#import "WiKiListViewController.h"

@interface BaseTabBarViewController ()
{
    UINavigationController *_essentialNC;
    UINavigationController *_forumNC;
    UINavigationController *_wikiNC;
    UINavigationController *_meNC;
}
@end

@implementation BaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    self.view.backgroundColor = RGB(242, 242, 242);
    [self setupTabBarItems];
    
    [self setupTabBarStyle];
}

- (void)setupTabBarItems
{
    UIEdgeInsets insets = UIEdgeInsetsMake(6.0, 0.0, -6.0, 0.0);

    EssentialListViewController *essentialListVC = [[EssentialListViewController alloc] init];
    _essentialNC = [[UINavigationController alloc] initWithRootViewController:essentialListVC];
    _essentialNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"essential_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"essential_selected_icon.png"]];
    _essentialNC.tabBarItem.imageInsets = insets;
    
    TopicListContainerViewController *topicListContainerVC = [[TopicListContainerViewController alloc] init];
    _forumNC = [[UINavigationController alloc] initWithRootViewController:topicListContainerVC];
    _forumNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"forum_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"forum_selected_icon.png"]];
    _forumNC.tabBarItem.imageInsets = insets;
    
    WiKiListViewController *wikiListVC = [[WiKiListViewController alloc] init];
    _wikiNC = [[UINavigationController alloc] initWithRootViewController:wikiListVC];
    _wikiNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"wiki_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"wiki_selected_icon.png"]];
    _wikiNC.tabBarItem.imageInsets = UIEdgeInsetsMake(7.0, 0.0, -7.0, 0.0);;
    
    _meNC = [[UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
    _meNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[[UIImage imageNamed:@"me_icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[UIImage imageNamed:@"me_selected_icon.png"]];
    _meNC.tabBarItem.badgeValue = nil;
    _meNC.tabBarItem.imageInsets = insets;
    
    NSArray *controllers = @[_essentialNC, _forumNC, _wikiNC, _meNC];
    [self setViewControllers:controllers];
    
}

- (void)setupTabBarStyle
{
    // for shouldSelectViewController, enabling animation for tabbar item clicked.
    [self setDelegate:self];
    
    // White background
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_background.png"]];
}

#pragma mark - Delegate - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    CATransition *animation = [CATransition animation];
    [animation setType:kCATransitionFade];
    [animation setDuration:0.25];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:
                                  kCAMediaTimingFunctionEaseIn]];
    [self.view.window.layer addAnimation:animation forKey:@"fadeTransition"];
    
    return YES;
}

- (void)jumpToViewController:(UIViewController *)viewController {
    if([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *)self.selectedViewController;
        [navigation pushViewController:viewController animated:NO];
    }
}

- (void)jumpToViewControllerWithAnimation:(UIViewController *)viewController {
    if([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigation = (UINavigationController *)self.selectedViewController;
        [navigation pushViewController:viewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
