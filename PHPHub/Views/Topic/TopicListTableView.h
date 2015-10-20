//
//  TopicListTableView.h
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TopicListTableViewDelegate <NSObject>
- (void)headerRefreshing;
- (void)footerRereshing;
@end

@interface TopicListTableView : UITableView
@property (nonatomic, assign) BOOL shouldRemoveHeaderView;
@property (nonatomic, strong) NSMutableArray *topicEntites;
@property (nonatomic, weak) id<TopicListTableViewDelegate> topicListTableViewDelegate;
- (void)setupFooterView;
@end
