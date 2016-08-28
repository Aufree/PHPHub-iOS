//
//  TopicListViewController.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicListTableView.h"

typedef NS_ENUM(NSInteger, TopicListType) {
    TopicListTypeNewest = 0,
    TopicListTypeHots = 1,
    TopicListTypeNoReply = 2,
    TopicListTypeJob = 3,
    TopicListTypeVoted = 4,
    TopicListTypeNormal = 5,
};

@interface TopicListViewController : UIViewController
@property (nonatomic) TopicListType topicListType;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) TopicListTableView *tableView;
@property (nonatomic, assign) BOOL isFromTopicContainer;
@end
