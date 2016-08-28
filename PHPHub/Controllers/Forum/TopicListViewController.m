//
//  TopicListViewController.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicListViewController.h"
#import "TopicEntity.h"
#import "TopicModel.h"

@interface TopicListViewController () <TopicListTableViewDelegate>
@property (nonatomic, strong) NSMutableArray *topicEntites;
@property (nonatomic, strong) PaginationEntity *pagination;
@end

@implementation TopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[TopicListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.topicListTableViewDelegate = self;
    
    if (self.isFromTopicContainer) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 112, 0);
    }
    
    [self.view addSubview:self.tableView];

    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefreshing {
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.topicEntites = data[@"entities"];
            weakself.pagination = data[@"pagination"];
            [weakself.tableView reloadData];
        }
        
        [weakself.tableView.mj_header endRefreshing];
        
        if (weakself.pagination.totalPages > 1) {
            [weakself.tableView setupFooterView];
        }
    };
    
    [self fetchDataSource:callback atPage:1];
}

- (void)footerRereshing {
    NSUInteger maxPage = self.pagination.totalPages;
    NSUInteger nextPage = self.pagination.currentPage + 1;
    
    if (nextPage <= maxPage) {
        __weak typeof(self) weakself = self;
        BaseResultBlock callback = ^(NSDictionary *data, NSError *error) {
            if (!error) {
                NSArray *newData  = [data objectForKey:@"entities"];
                
                [weakself.topicEntites addObjectsFromArray:newData];
                weakself.pagination = data[@"pagination"];
                [weakself.tableView reloadData];
            }
            [weakself.tableView.mj_footer endRefreshing];
        };
        
        [self fetchDataSource:callback atPage:nextPage];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}

- (void)setTopicEntites:(NSMutableArray *)topicEntites {
    _topicEntites = topicEntites;
    self.tableView.topicEntites = _topicEntites;
}

- (void)fetchDataSource:(BaseResultBlock)callback atPage:(NSUInteger)atPage {
    if (self.topicListType == TopicListTypeNewest) {
        [[TopicModel Instance] getNewestTopicList:callback atPage:atPage];
        self.navigationItem.title = @"最新帖子";
    } else if (self.topicListType == TopicListTypeHots) {
        [[TopicModel Instance] getHotsTopicList:callback atPage:atPage];
        self.navigationItem.title = @"最热帖子";
    } else if (self.topicListType == TopicListTypeNoReply) {
        [[TopicModel Instance] getNoReplyTopicList:callback atPage:atPage];
        self.navigationItem.title = @"冷门帖子";
    } else if (self.topicListType == TopicListTypeJob) {
        [[TopicModel Instance] getJobTopicList:callback atPage:atPage];
        self.navigationItem.title = @"招聘帖子";
    } else if (self.topicListType == TopicListTypeVoted && self.userId > 0) {
        [[TopicModel Instance] getVotedTopicListByUser:self.userId callback:callback atPage:atPage];
        self.navigationItem.title = @"赞过的帖子";
    } else if (self.topicListType == TopicListTypeNormal && self.userId > 0) {
        [[TopicModel Instance] getTopicListByUser:self.userId callback:callback atPage:atPage];
        self.navigationItem.title = @"发布的帖子";
    }
}

@end