//
//  TopicListViewController.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicListViewController.h"

#import "TopicListCell.h"
#import "TopicEntity.h"
#import "TopicModel.h"

@interface TopicListViewController ()
@property (nonatomic, strong) NSMutableArray *topicEntites;
@property (nonatomic, strong) PaginationEntity *pagination;
@end

@implementation TopicListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    self.navigationItem.title = @"社区 WiKi";
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
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

- (void)fetchDataSource:(BaseResultBlock)callback atPage:(NSUInteger)atPage {
    if (self.topicListType == TopicListTypeNewest) {
        [[TopicModel Instance] getNewestTopicList:callback atPage:atPage];
    } else if (self.topicListType == TopicListTypeHots) {
        [[TopicModel Instance] getHotsTopicList:callback atPage:atPage];
    } else if (self.topicListType == TopicListTypeNoReply) {
        [[TopicModel Instance] getNoReplyTopicList:callback atPage:atPage];
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
    static NSString *topicListIdentifier = @"topicListIdentifier";
    
    TopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:topicListIdentifier];
    
    if (self.topicEntites.count > 0) {
        TopicEntity *topicEntity = self.topicEntites[indexPath.row];
        cell = [[TopicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topicListIdentifier];
        cell.backgroundColor = self.tableView.backgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.topicEntity = topicEntity;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10.0)];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

@end
