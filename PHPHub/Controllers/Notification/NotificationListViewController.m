//
//  NotificationListViewController.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationListViewController.h"
#import "NotificationListCell.h"
#import "NotificationEntity.h"
#import "NotificationModel.h"

@interface NotificationListViewController ()
@property (nonatomic, strong) NSMutableArray *notificationEntities;
@property (nonatomic, strong) PaginationEntity *pagination;
@end

@implementation NotificationListViewController

- (void)viewDidLoad {    
    [super viewDidLoad];
    
    self.tableView = [[NotificationListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];    
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"我的消息";
    [self setupHeaderView];
    [self.tableView.header beginRefreshing];
}

- (void)setupHeaderView {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.font = [UIFont fontWithName:FontName size:13];
    self.tableView.header = header;
}
#pragma mark Get Topic Data

- (void)headerRefreshing {
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.notificationEntities = data[@"entities"];
            weakself.pagination = data[@"pagination"];
            [weakself.tableView reloadData];
        }
        
        [weakself.tableView.header endRefreshing];
        if (weakself.pagination.totalPages > 1) {
            MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
            footer.stateLabel.font = [UIFont fontWithName:FontName size:13];
            self.tableView.footer = footer;
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
                
                [weakself.notificationEntities addObjectsFromArray:newData];
                weakself.pagination = data[@"pagination"];
                [weakself.tableView reloadData];
            }
            [weakself.tableView.footer endRefreshing];
        };
        
        [self fetchDataSource:callback atPage:nextPage];
    } else {
        [self.tableView.footer endRefreshing];
        [self.tableView.footer noticeNoMoreData];
    }
    
}

- (void)setNotificationEntities:(NSMutableArray *)notificationEntities {
    _notificationEntities = notificationEntities;
    self.tableView.notificationEntities = _notificationEntities;
}

- (void)fetchDataSource:(BaseResultBlock)callback atPage:(NSUInteger)atPage {
    [[NotificationModel Instance] getNotificationList:callback atPage:atPage];
}

@end
