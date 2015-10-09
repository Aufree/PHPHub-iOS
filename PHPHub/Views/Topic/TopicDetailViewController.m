//
//  TopicDetailViewController.m
//  PHPHub
//
//  Created by Aufree on 10/8/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicModel.h"
#import "AccessTokenHandler.h"
#import "UserProfileViewController.h"
#import "TOWebViewController.h"
#import "ReplyTopicViewController.h"

@interface TopicDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voteStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIWebView *topicContentWeb;
@property (weak, nonatomic) IBOutlet UIView *topicToolBarView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    _topicContentWeb.delegate = self;
    [self updateTopicDetailView];
    
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.topic = data[@"entity"];
            [weakself loadTopicContentWebView];
        }
    };
    
    [[TopicModel Instance] getTopicById:_topic.topicId.integerValue callback:callback];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _topicToolBarView.hidden = NO;
}

- (void)updateTopicDetailView {
    UserEntity *user = _topic.user;
    NSURL *url = [BaseHelper qiniuImageCenter:user.avatar withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _usernameLabel.text = user.username;
    _signatureLabel.text = user.signature;
    _voteCountLabel.text = _topic.voteCount.stringValue;
    NSString *rawTopicCount = _topic.topicRepliesCount.integerValue > 99 ? @"99+" : _topic.topicRepliesCount.stringValue;
    NSString *topicCount = [NSString stringWithFormat:@" %@", rawTopicCount];
    [_commentsButton setTitle:topicCount forState:UIControlStateNormal];
}

#pragma mark Load WebView

- (void)loadTopicContentWebView {
    NSURL *url = [NSURL URLWithString:_topic.topicContentUrl];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setValue:[AccessTokenHandler getClientGrantAccessTokenFromLocal] forHTTPHeaderField:@"Authorization"];
    [_topicContentWeb loadRequest:requestObj];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        NSURL *url = [request URL];
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURL:url];
        [self.navigationController pushViewController:webVC animated:YES];
        return NO;
    }
    
    return YES;
}

#pragma mark Touch User Avatar

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == _avatarImageView) {
        [self didTapAvatarImageView];
    }
    
}

- (void)didTapAvatarImageView {
    UserProfileViewController *userProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile"
                                                                          bundle:[NSBundle mainBundle]]
                                                instantiateViewControllerWithIdentifier:@"userprofile"];
    userProfileVC.userEntity = _topic.user;
    [self.navigationController pushViewController:userProfileVC animated:YES];
}

# pragma mark Topic Detail Action

- (IBAction)didTouchReplyButton:(id)sender {
    ReplyTopicViewController *replyTopicVC = [[UIStoryboard storyboardWithName:@"Topic" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"replyTopic"];
    [self.navigationController pushViewController:replyTopicVC animated:YES];
}

@end