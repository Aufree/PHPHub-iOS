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

@interface TopicListTableView() <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TopicListTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        self.topicEntites = [[NSMutableArray alloc] init];
        
        [self reloadData];
    }
    return self;
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
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Topic" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"topic"];
    [JumpToOtherVCHandler pushToOtherView:vc animated:YES];
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
