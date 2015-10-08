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

@interface TopicDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voteStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIWebView *topicContentWeb;
@property (weak, nonatomic) IBOutlet UITabBar *topicTabbar;
@property (strong, nonatomic) TopicEntity *topic;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
    _avatarImageView.layer.masksToBounds = YES;
    _avatarImageView.userInteractionEnabled = YES;
    _topicContentWeb.delegate = self;
    
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.topic = data[@"entity"];
            [weakself updateTopicDetailView];
            [weakself loadTopicContentWebView];
        }
    };
    
    [[TopicModel Instance] getTopicById:self.topicId callback:callback];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _topicTabbar.hidden = NO;
}

- (void)updateTopicDetailView {
    UserEntity *user = _topic.user;
    NSURL *url = [BaseHelper qiniuImageCenter:user.avatar withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _usernameLabel.text = user.username;
    _signatureLabel.text = @"Hello World";
    _voteCountLabel.text = _topic.voteCount.stringValue;
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
@end
