//
//  TopicDetailViewController.m
//  PHPHub
//
//  Created by Aufree on 10/8/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicModel.h"

@interface TopicDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *voteStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *voteCountLabel;
@property (weak, nonatomic) IBOutlet UIWebView *topicContentWeb;
@property (strong, nonatomic) TopicEntity *topic;
@end

@implementation TopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.topic = data[@"entity"];
            [weakself updateTopicDetailView];
        }
    };
    
    [[TopicModel Instance] getTopicById:self.topicId callback:callback];
}

- (void)updateTopicDetailView {
    UserEntity *user = _topic.user;
    NSURL *url = [BaseHelper qiniuImageCenter:user.avatar withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _usernameLabel.text = user.username;
    _signatureLabel.text = user.signature;
    _voteCountLabel.text = _topic.voteCount.stringValue;
}
@end
