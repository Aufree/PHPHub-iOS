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

#import "AccessTokenHandler.h"

@interface CommentListViewController () <UIWebViewDelegate, ReplyTopicViewControllerDelegate>
@property (nonatomic, strong) UIWebView *commentsWebView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@end

@implementation CommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"回复列表";
    
    [self.view addSubview:self.commentsWebView];
    [self.view addSubview:self.activityView];
    
    [self createRightBarButtonItem];
    [self loadTopicContentWebView];
}

- (UIWebView *)commentsWebView {
    if (!_commentsWebView) {
        _commentsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _commentsWebView.delegate = self;
    }
    return _commentsWebView;
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.center = CGPointMake(self.view.width/2, self.view.height/2);
        [_activityView startAnimating];
    }
    return _activityView;
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

- (void)loadTopicContentWebView {
    NSURL *url = [NSURL URLWithString:_topic.topicRepliesUrl];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setValue:[AccessTokenHandler getClientGrantAccessTokenFromLocal] forHTTPHeaderField:@"Authorization"];
    [_commentsWebView loadRequest:requestObj];
}

#pragma mark WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *url = [request URL];
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _activityView.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    _activityView.hidden = YES;
}

- (void)reloadCommentListView {
    [_commentsWebView reload];
}
@end
