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
#import "TopicVoteView.h"

@interface TopicDetailViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteButton;
@property (weak, nonatomic) IBOutlet UIWebView *topicContentWeb;
@property (weak, nonatomic) IBOutlet UIView *topicToolBarView;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *watchButton;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *commentsButton;
@property (assign, nonatomic) BOOL isFavoriteTopic;
@property (assign, nonatomic) BOOL isAttentionTopic;
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
            weakself.isFavoriteTopic = weakself.topic.favorite;
            weakself.isAttentionTopic = weakself.topic.attention;
            [weakself updateFavoriteButtonStateWithFavarite];
            [weakself updateAttentionButtonStateWithAttention];            
            [weakself updateVoteState];
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
    NSString *voteCountString = [NSString stringWithFormat:@"  %@", _topic.voteCount.stringValue];
    [_voteButton setTitle:voteCountString forState:UIControlStateNormal];
    NSString *rawTopicCount = _topic.topicRepliesCount.integerValue > 99 ? @"99+" : _topic.topicRepliesCount.stringValue;
    NSString *topicCount = [NSString stringWithFormat:@" %@", rawTopicCount];
    [_commentsButton setTitle:topicCount forState:UIControlStateNormal];
}

- (void)updateVoteState {
    if (_topic.voteUp && !_topic.voteDown) {
        [_voteButton setImage:[UIImage imageNamed:@"upvote_icon"] forState:UIControlStateNormal];
    } else if (_topic.voteDown && !_topic.voteUp) {
        [_voteButton setImage:[UIImage imageNamed:@"downvote_icon"] forState:UIControlStateNormal];
    } else {
        [_voteButton setImage:[UIImage imageNamed:@"vote_icon"] forState:UIControlStateNormal];
    }
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

- (IBAction)didTouchFavoriteButton:(id)sender {
    
    if (_isFavoriteTopic) {
        _isFavoriteTopic = NO;
        [[TopicModel Instance] cancelFavoriteTopicById:_topic.topicId withBlock:nil];
    } else {
        _isFavoriteTopic = YES;
        [[TopicModel Instance] favoriteTopicById:_topic.topicId withBlock:nil];
    }
    
    [self updateFavoriteButtonStateWithFavarite];
}

- (IBAction)didTouchAttentionButton:(id)sender {
    if (_isAttentionTopic) {
        _isAttentionTopic = NO;
        [[TopicModel Instance] cancelAttentionTopicById:_topic.topicId withBlock:nil];
    } else {
        _isAttentionTopic = YES;
        [[TopicModel Instance] attentionTopicById:_topic.topicId withBlock:nil];
    }
    
    [self updateAttentionButtonStateWithAttention];
}

- (void)updateFavoriteButtonStateWithFavarite {
    if (_isFavoriteTopic) {
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite_blue_icon"] forState:UIControlStateNormal];
    } else {
        [_favoriteButton setImage:[UIImage imageNamed:@"favorite_icon"] forState:UIControlStateNormal];
    }
}

- (void)updateAttentionButtonStateWithAttention {
    if (_isAttentionTopic) {
        [_watchButton setImage:[UIImage imageNamed:@"watch_blue_icon"] forState:UIControlStateNormal];
    } else {
        [_watchButton setImage:[UIImage imageNamed:@"watch_icon"] forState:UIControlStateNormal];
    }
}

- (IBAction)didTouchVoteButton:(id)sender {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    TopicVoteView *topicVoteView = [[TopicVoteView alloc] initWithFrame:keyWindow.bounds topicEntity:_topic];
    [topicVoteView.upVoteButton addTarget:self action:@selector(upVoteTopic) forControlEvents:UIControlEventTouchUpInside];
    [topicVoteView.downVoteButton addTarget:self action:@selector(downVoteTopic) forControlEvents:UIControlEventTouchUpInside];
    [keyWindow addSubview: topicVoteView];
}

- (IBAction)didTouchReplyButton:(id)sender {
    ReplyTopicViewController *replyTopicVC = [[UIStoryboard storyboardWithName:@"Topic" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"replyTopic"];
    replyTopicVC.topicId = _topic.topicId;
    [self.navigationController pushViewController:replyTopicVC animated:YES];
}

- (IBAction)didTouchCommentsButton:(id)sender {
    if (_topic.topicRepliesUrl) {
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:_topic.topicRepliesUrl];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)upVoteTopic {
    _topic.voteUp = !_topic.voteUp;
    NSInteger voteCount = _topic.voteCount.integerValue;
    voteCount = _topic.voteUp ? voteCount + 1 : voteCount - 1;
    _topic.voteCount = @(voteCount);
    [_voteButton setTitle:[NSString stringWithFormat:@"  %ld", voteCount] forState:UIControlStateNormal];
    [[TopicModel Instance] voteUpTopic:_topic.topicId withBlock:nil];
    [self updateVoteState];
}

- (void)downVoteTopic {
    _topic.voteDown = !_topic.voteDown;
    NSInteger voteCount = _topic.voteCount.integerValue;
    voteCount = _topic.voteDown ? voteCount - 1 : voteCount + 1;
    _topic.voteCount = @(voteCount);
    [_voteButton setTitle:[NSString stringWithFormat:@"  %ld", voteCount] forState:UIControlStateNormal];
    [[TopicModel Instance] voteDownTopic:_topic.topicId withBlock:nil];
    [self updateVoteState];
}
@end