//
//  TopicVoteView.h
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopicVoteView : UIView
@property (nonatomic, strong) UIButton *upVoteButton;
@property (nonatomic, strong) UIButton *downVoteButton;
- (instancetype)initWithFrame:(CGRect)frame topicEntity:(TopicEntity *)topic;
@end
