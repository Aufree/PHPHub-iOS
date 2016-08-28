//
//  MeViewController.m
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "MeViewController.h"
#import "NotificationListViewController.h"
#import "LoginViewController.h"
#import "UserProfileViewController.h"
#import "TopicListViewController.h"
#import "SettingsViewController.h"
#import "CommentListViewController.h"
#import "TOWebViewController.h"

@interface MeViewController () <LoginViewControllerDelegate>
@property (nonatomic, strong) UserEntity *userEntity;
@property (weak, nonatomic) IBOutlet UILabel *unreadCountLabel;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadCount:) name:UpdateNoticeCount object:nil];
    self.navigationItem.title = @"我的";
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    [self setupCornerRadiusWithView:@[_avatarImageView, _unreadCountLabel]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[CurrentUser Instance] isLogin]) {
        [self updateMeView];
        [self setupUnreadCountLabel];
    } else {
        LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Passport"
                                                                  bundle:[NSBundle mainBundle]]
                                        instantiateViewControllerWithIdentifier:@"login"];
        loginVC.delegate = self;
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

- (void)setupCornerRadiusWithView:(NSArray *)views {
    for (UIView *view in views) {
        view.layer.cornerRadius = view.height/2;
        view.layer.masksToBounds = YES;
    }
}

- (void)setupUnreadCountLabel {
    if (self.navigationController.tabBarItem.badgeValue.integerValue > 0) {
        _unreadCountLabel.hidden = NO;
        _unreadCountLabel.text = self.navigationController.tabBarItem.badgeValue;
    }
}

- (void)updateUnreadCount:(NSNotification *)notification {
    NSNumber *unreadCount = notification.userInfo[@"unreadCount"];
    if (unreadCount.integerValue > 0) {
        _unreadCountLabel.hidden = NO;
        _unreadCountLabel.text = unreadCount.stringValue;
    } else {
        _unreadCountLabel.hidden = YES;
    }
}

- (void)updateMeView {
    self.userEntity = [CurrentUser Instance].userInfo;
    
    if (_userEntity) {
        NSString *avatarHeight = [NSString stringWithFormat:@"%.f", _avatarImageView.height * 2];
        NSURL *URL = [BaseHelper qiniuImageCenter:_userEntity.avatar withWidth:avatarHeight withHeight:avatarHeight];
        [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _usernameLabel.text = _userEntity.username;
        _userIntroLabel.text = [NSString isStringEmpty:_userEntity.introduction] ? @"个人签名为空哦 :)" : _userEntity.introduction;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 1.0f : UITableViewAutomaticDimension;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return section == 0 ? nil : @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIViewController *vc;
    if (section == 0 && row == 0) {
        UserProfileViewController *userProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile"
                                                                              bundle:[NSBundle mainBundle]]
                                                    instantiateViewControllerWithIdentifier:@"userprofile"];
        userProfileVC.userEntity = _userEntity;
        vc = userProfileVC;
    } else if (section == 1) {
        switch (row) {
            case 0: {
                NotificationListViewController *notificationListVC = [[NotificationListViewController alloc] init];
                vc = notificationListVC;
                break;
            } case 1: {
                vc = [self createTopicListWithType:TopicListTypeVoted];
                break;
            }
        }
    } else if (section == 2) {
        if (row == 0) {
            vc = [self createTopicListWithType:TopicListTypeNormal];
        } else if (row == 1) {
            [self jumpToCommentListView];
        } else if (row == 2) {
            vc = [[UIStoryboard storyboardWithName:@"Settings" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"settings"];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (vc) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (TopicListViewController *)createTopicListWithType:(TopicListType)topicListType {
    TopicListViewController *topicListVC = [[TopicListViewController alloc] init];
    topicListVC.userId = [[CurrentUser Instance] userId].integerValue;
    topicListVC.topicListType = topicListType;
    return topicListVC;
}

- (void)jumpToCommentListView {
    CommentListViewController *commentListVC = [[CommentListViewController alloc] init];
    commentListVC.hidesBottomBarWhenPushed = YES;
    TopicEntity *topic = [TopicEntity new];
    topic.topicRepliesUrl = _userEntity.repliesUrl;
    commentListVC.topic = topic;
    [self.navigationController pushViewController:commentListVC animated:YES];
}

@end