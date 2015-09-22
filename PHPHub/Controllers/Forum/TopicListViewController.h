//
//  TopicListViewController.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopicListType) {
    TopicListTypeNewest = 0,
    TopicListTypeHots = 1,
    TopicListTypeNoReply = 2,
};

@interface TopicListViewController : UITableViewController
@property (nonatomic) TopicListType topicListType;
@end
