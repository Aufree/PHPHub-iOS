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

@interface TopicListViewController ()
@property (nonatomic, strong) NSMutableArray *topicEntites;
@property (nonatomic, strong) PaginationEntity *pagination;
@end

@implementation TopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[TopicListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    if (self.isFromTopicContainer) {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 112, 0);
    }
    
    [self.view addSubview:self.tableView];
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    [self.tableView.header beginRefreshing];
}

- (void)headerRefreshing {
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.topicEntites = data[@"entities"];
            weakself.pagination = data[@"pagination"];
            [weakself.tableView reloadData];
        }
        
        [weakself.tableView.header endRefreshing];
        weakself.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    };
    
    [self fetchDataSource:callback atPage:1];
}

- (void)footerRereshing
{
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
            [weakself.tableView.footer endRefreshing];
        };
        
        [self fetchDataSource:callback atPage:nextPage];
    } else {
        [self.tableView.footer endRefreshing];
    }
    
}

- (void)setTopicEntites:(NSMutableArray *)topicEntites {
    _topicEntites = topicEntites;
    self.tableView.topicEntites = _topicEntites;
}

- (void)fetchDataSource:(BaseResultBlock)callback atPage:(NSUInteger)atPage {
    if (self.topicListType == TopicListTypeNewest) {
        [[TopicModel Instance] getNewestTopicList:callback atPage:atPage];
    } else if (self.topicListType == TopicListTypeHots) {
        [[TopicModel Instance] getHotsTopicList:callback atPage:atPage];
    } else if (self.topicListType == TopicListTypeNoReply) {
        [[TopicModel Instance] getNoReplyTopicList:callback atPage:atPage];
    } else if (self.topicListType == TopicListTypeJob) {
        [[TopicModel Instance] getJobTopicList:callback atPage:atPage];
    } else if (self.topicListType == TopicListTypeFavorite && self.userId > 0) {
        [[TopicModel Instance] getFavoriteTopicListByUser:self.userId callback:callback atPage:atPage];
        self.navigationItem.title = @"收藏的帖子";
    } else if (self.topicListType == TopicListTypeAttention && self.userId > 0) {
        [[TopicModel Instance] getAttentionTopicListByUser:self.userId callback:callback atPage:atPage];
        self.navigationItem.title = @"关注的帖子";
    } else if (self.topicListType == TopicListTypeNormal && self.userId > 0) {
        [[TopicModel Instance] getTopicListByUser:self.userId callback:callback atPage:atPage];
        self.navigationItem.title = @"发布的帖子";
    }
}

@end