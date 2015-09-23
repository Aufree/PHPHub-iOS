//
//  EssentialListViewController.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "EssentialListViewController.h"
#import "TopicListTableView.h"
#import "TopicEntity.h"
#import "TopicModel.h"

@interface EssentialListViewController ()
@property (nonatomic, strong) TopicListTableView *tableView;
@property (nonatomic, strong) NSMutableArray *topicEntites;
@property (nonatomic, strong) PaginationEntity *pagination;
@end

@implementation EssentialListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[TopicListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.navigationItem.title = @"精华";
    
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
    [[TopicModel Instance] getAllTopic:callback atPage:atPage];
}

@end