//
//  NotificationListTableView.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationListTableView.h"
#include "NotificationListCell.h"
#import "NotificationEntity.h"
#import "TopicDetailViewController.h"
#import "UIScrollView+EmptyDataSet.h"
#import "EmptyTopicView.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *notificationListIdentifier = @"notificationListIdentifier";

@interface NotificationListTableView () <UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation NotificationListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self registerClass:[NotificationListCell class] forCellReuseIdentifier:notificationListIdentifier];
    self.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = self;
    self.delegate = self;
    self.notificationEntities = [[NSMutableArray alloc] init];
    [self reloadData];
    [self setupEmptyDataSet];
}

- (void)setupEmptyDataSet {
    self.emptyDataSetDelegate = self;
    self.emptyDataSetSource = self;
}

- (void)setNotificationEntities:(NSMutableArray *)notificationEntities {
    _notificationEntities = notificationEntities;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notificationEntities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationListCell *cell = [tableView dequeueReusableCellWithIdentifier:notificationListIdentifier];
    
    if (!cell) {
        cell = [[NotificationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:notificationListIdentifier];
    }
    
    if (_notificationEntities.count > 0) {
        NotificationEntity *notificationEntity = self.notificationEntities[indexPath.row];
        cell.backgroundColor = self.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.notificationEntity = notificationEntity;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:notificationListIdentifier configuration:^(NotificationListCell *cell) {
        if (_notificationEntities.count > 0) {
            NotificationEntity *notificationEntity = self.notificationEntities[indexPath.row];
            cell.notificationEntity = notificationEntity;
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationEntity *notification = [_notificationEntities objectAtIndex:indexPath.row];
    TopicEntity *topic = notification.topic;
    TopicDetailViewController *topicDetailVC = [[UIStoryboard storyboardWithName:@"Topic" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"topic"];
    topicDetailVC.topic = topic;
    [JumpToOtherVCHandler pushToOtherView:topicDetailVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    EmptyTopicView *emptyTopicView = [[EmptyTopicView alloc] initWithFrame:self.bounds];
    return emptyTopicView;
}

@end
