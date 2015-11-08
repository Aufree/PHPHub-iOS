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
#import "PostTopicViewController.h"

@interface EssentialListViewController () <TopicListTableViewDelegate>
@property (nonatomic, strong) TopicListTableView *tableView;
@property (nonatomic, strong) NSMutableArray *topicEntites;
@property (nonatomic, strong) PaginationEntity *pagination;
@end

@implementation EssentialListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[TopicListTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.topicListTableViewDelegate = self;
    [self.view addSubview:self.tableView];
    self.navigationItem.title = @"精华";

    [self checkCurrentUserClientToken];
    [self createRightButtonItem];    
}

#pragma mark Check current user client token

- (void)checkCurrentUserClientToken {
    // Get the client token from server
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        [weakself.tableView.mj_header beginRefreshing];
    };

    [[CurrentUser Instance] setupClientRequestState:callback];
}

#pragma mark Get Topic Data

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
    [[TopicModel Instance] getExcellentTopicList:callback atPage:atPage];
}

#pragma mark Right bar button item

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"pencil_square_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(jumpToPostTopicVC)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)jumpToPostTopicVC {
    [self checkUserPermissionWithAction:^{
        PostTopicViewController *postTopicVC = [[UIStoryboard storyboardWithName:@"Topic" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"postTopic"];
        [self.navigationController pushViewController:postTopicVC animated:YES];
    }];
}

- (void)checkUserPermissionWithAction:(void (^)(void))completion {
    if ([[CurrentUser Instance] isLogin]) {
        if (completion) completion();
    } else {
        [JumpToOtherVCHandler jumpToLoginVC:completion];
    }
}
@end