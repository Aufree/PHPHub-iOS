//
//  CommentListViewController.m
//  PHPHub
//
//  Created by Aufree on 10/26/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "CommentListViewController.h"
#import "ReplyTopicViewController.h"
#import "TOWebViewController.h"
#import "BaseWebView.h"

#import "AccessTokenHandler.h"

@interface CommentListViewController () <ReplyTopicViewControllerDelegate>
@property (nonatomic, strong) BaseWebView *commentsWebView;
@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回复列表";
    
    [self.view addSubview:self.commentsWebView];
    
    [self createRightBarButtonItem];
}

- (UIWebView *)commentsWebView {
    if (!_commentsWebView) {
        _commentsWebView = [[BaseWebView alloc] initWithFrame:self.view.bounds urlString:_topic.topicRepliesUrl];
    }
    return _commentsWebView;
}

- (void)createRightBarButtonItem {
    if ([[CurrentUser Instance] isLogin]) {
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_profile_icon"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(jumpToReplyTopicVC)];
        rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
        self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    }
}

- (void)jumpToReplyTopicVC {
    ReplyTopicViewController *replyTopicVC = [[UIStoryboard storyboardWithName:@"Topic" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"replyTopic"];
    replyTopicVC.topicId = _topic.topicId;
    replyTopicVC.delegate = self;
    [self.navigationController pushViewController:replyTopicVC animated:YES];
}

#pragma mark Load WebView

- (void)reloadCommentListView {
    [_commentsWebView reload];
}
@end
