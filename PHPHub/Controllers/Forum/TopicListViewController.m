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
@property (nonatomic, copy) NSArray *topicEntites;
@end

@implementation TopicListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    self.navigationItem.title = @"社区 WiKi";
    
    [self fetchEssentialListData];
}

- (void)fetchEssentialListData {
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.topicEntites = data[@"entities"];
            [weakself.tableView reloadData];
        }
    };
    
    if (self.topicListType == TopicListTypeNewest) {
        [[TopicModel Instance] getNewestTopicList:callback atPage:1];
    } else if (self.topicListType == TopicListTypeHots) {
        [[TopicModel Instance] getHotsTopicList:callback atPage:1];
    } else if (self.topicListType == TopicListTypeNoReply) {
        [[TopicModel Instance] getNoReplyTopicList:callback atPage:1];
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
