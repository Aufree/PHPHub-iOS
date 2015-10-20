//
//  TopicListTableView.m
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicListTableView.h"
#import "TopicListCell.h"
#import "TopicEntity.h"
#import "TopicDetailViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"

static NSString *topicListIdentifier = @"topicListIdentifier";

@interface TopicListTableView() <UITableViewDelegate, UITableViewDataSource>
@end

@implementation TopicListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self registerClass:[TopicListCell class] forCellReuseIdentifier:topicListIdentifier];
    self.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.dataSource = self;
    self.delegate = self;
    self.topicEntites = [[NSMutableArray alloc] init];
    [self setupHeaderView];
    [self reloadData];
}

- (void)setupHeaderView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont fontWithName:FontName size:13];
    self.header = header;
}

- (void)setupFooterView {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    footer.stateLabel.font = [UIFont fontWithName:FontName size:13];
    self.footer = footer;
}

- (void)refreshData {
    if (_topicListTableViewDelegate && [_topicListTableViewDelegate respondsToSelector:@selector(headerRefreshing)]) {
        [_topicListTableViewDelegate headerRefreshing];
    }
}

- (void)loadMoreData {
    if (_topicListTableViewDelegate && [_topicListTableViewDelegate respondsToSelector:@selector(footerRereshing)]) {
        [_topicListTableViewDelegate footerRereshing];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicEntites.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:topicListIdentifier];
    
    if (!cell) {
        cell = [[TopicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicListIdentifier];
    }
    
    if (self.topicEntites.count > 0) {
        TopicEntity *topicEntity = self.topicEntites[indexPath.row];
        cell.backgroundColor = self.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.topicEntity = topicEntity;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicEntity *topic = [_topicEntites objectAtIndex:indexPath.row];
    TopicDetailViewController *topicDetailVC = [[UIStoryboard storyboardWithName:@"Topic" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"topic"];
    topicDetailVC.topic = topic;
    [JumpToOtherVCHandler pushToOtherView:topicDetailVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0)];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:topicListIdentifier configuration:^(TopicListCell *cell) {
        if (_topicEntites.count > 0) {
            TopicEntity *topic = [_topicEntites objectAtIndex:indexPath.row];
            cell.topicEntity = topic;
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _shouldRemoveHeaderView ? 0 : 10;
}

@end
