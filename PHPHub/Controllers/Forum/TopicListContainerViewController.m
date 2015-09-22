//
//  TopicListContainerViewController.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicListContainerViewController.h"
#import "TopicListViewController.h"
#import "TitlePagerView.h"

@interface TopicListContainerViewController () <ViewPagerDataSource, ViewPagerDelegate, TitlePagerViewDelegate>
@property (nonatomic, strong) TopicListViewController *newestTopicListVC;
@property (nonatomic, strong) TopicListViewController *hotsTopicListVC;
@property (nonatomic, strong) TopicListViewController *noReplyTopicListVC;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) TitlePagerView *pagingTitleView;
@end

@implementation TopicListContainerViewController


- (void)viewDidLoad {
    
    self.dataSource = self;
    self.delegate = self;
    
    // Do not auto load data
    self.manualLoadData = YES;
    
    // Keeps tab bar below navigation bar on iOS 7.0+
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.translucent = YES;
    
    self.currentIndex = 0;
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.pagingTitleView;

    [self reloadData];
}

#pragma mark - ViewPagerDataSource
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 3;
}

- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    NSString *labelText = nil;
    switch (index) {
        case 0:
            labelText = @"最新";
            break;
        case 1:
            labelText = @"热门";
            break;
        case 2:
            labelText = @"冷门";
            break;
        default:
            break;
    }
    UILabel *label = [UILabel new];
    label.font = [UIFont fontWithName:@"Arial" size:15.0f];
    label.text = labelText;
    label.textAlignment = NSTextAlignmentCenter;
    
    [label sizeToFit];
    return label;
}

- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    if (index == 0) {
        return [self createNewestVC];
    } else if (index == 1) {
        return [self createHotsVC];
    } else {
        return [self createNoReplyVC];
    }
}

- (UIViewController *)createNewestVC {
    self.newestTopicListVC = [[TopicListViewController alloc] init];
    self.newestTopicListVC.topicListType = TopicListTypeNewest;
    return self.newestTopicListVC;
}

- (UIViewController *)createHotsVC {
    self.hotsTopicListVC = [[TopicListViewController alloc] init];
    self.hotsTopicListVC.topicListType = TopicListTypeHots;
    return self.hotsTopicListVC;
}

- (UIViewController *)createNoReplyVC {
    self.noReplyTopicListVC = [[TopicListViewController alloc] init];
    self.noReplyTopicListVC.topicListType = TopicListTypeNoReply;
    return self.noReplyTopicListVC;
}

#pragma mark - ViewPagerDelegate
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 1.0;
            break;
        case ViewPagerOptionTabWidth:
            return SCREEN_WIDTH / 2;
            break;
        default:
            break;
    }
    
    return value;
}

- (void)viewPager:(ViewPagerController *)viewPager didChangeTabToIndex:(NSUInteger)index {
    self.currentIndex = index;
}

- (TitlePagerView *)pagingTitleView
{
    if (!_pagingTitleView) {
        self.pagingTitleView = [[TitlePagerView alloc] init];
        self.pagingTitleView.frame = CGRectMake(0, 0, 0, 40);
        self.pagingTitleView.font = [UIFont systemFontOfSize:15];
        NSArray *titleArray = @[@"最新", @"热门", @"冷门"];
        self.pagingTitleView.width = [TitlePagerView calculateTitleWidth:titleArray withFont:self.pagingTitleView.font];
        [self.pagingTitleView addObjects:titleArray];
        self.pagingTitleView.delegate = self;
    }
    return _pagingTitleView;
}


- (void)didTouchBWTitle:(NSUInteger)index {
    //    NSInteger index;
    UIPageViewControllerNavigationDirection direction;
    
    if (self.currentIndex == index) {
        return;
    }
    
    if (index > self.currentIndex) {
        direction = UIPageViewControllerNavigationDirectionForward;
    } else {
        direction = UIPageViewControllerNavigationDirectionReverse;
    }
    
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    if (viewController) {
        __weak typeof(self) weakself = self;
        [self.pageViewController setViewControllers:@[viewController] direction:direction animated:YES completion:^(BOOL finished) {
            weakself.currentIndex = index;
        }];
    }
}

- (void)setCurrentIndex:(NSInteger)index
{
    _currentIndex = index;
    [self.pagingTitleView adjustTitleViewByIndex:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetX = scrollView.contentOffset.x;
    
    if (self.currentIndex != 0 && contentOffsetX <= SCREEN_WIDTH * 2) {
        contentOffsetX += SCREEN_WIDTH * self.currentIndex;
    }
    
    [self.pagingTitleView updatePageIndicatorPosition:contentOffsetX];
}

- (void)scrollEnabled:(BOOL)enabled {
    self.scrollingLocked = !enabled;
    
    for (UIScrollView *view in self.pageViewController.view.subviews) {
        if ([view isKindOfClass:[UIScrollView class]]) {
            view.scrollEnabled = enabled;
            view.bounces = enabled;
        }
    }
}

- (void)setSubViewScrollStatus:(BOOL)enabled {
//    UITableView *tableView = self.currentIndex == 0 ? self.showListVC.tableView : self.channelListVC.tableView;
//    tableView.bounces       = enabled;
//    tableView.scrollEnabled = enabled;
}
@end