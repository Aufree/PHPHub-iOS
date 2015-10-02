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

#import "UserModel.h"
#import "UserEntity.h"

@interface MeViewController ()
@property (nonatomic, strong) UserEntity *userEntity;
@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    if ([CurrentUser Instance].userInfo) {
        self.userEntity = [CurrentUser Instance].userInfo;
        [self updateMeView];
    } else {
        LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Passport"
                                                                  bundle:[NSBundle mainBundle]]
                                        instantiateViewControllerWithIdentifier:@"login"];
        [self.navigationController pushViewController:loginVC animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.userEntity = [data objectForKey:@"entity"];
            [weakself updateMeView];
        }
    };
    
    [[UserModel Instance] getCurrentUserData:callback];
}

- (void)updateMeView {
    if (_userEntity) {
        NSString *avatarHeight = [NSString stringWithFormat:@"%.f", _avatarImageView.height * 2];
        NSURL *URL = [BaseHelper qiniuImageCenter:_userEntity.avatar withWidth:avatarHeight withHeight:avatarHeight];
        [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
        _usernameLabel.text = _userEntity.username;
        _userIntroLabel.text = [NSString isStringEmpty:_userEntity.signature] ? @"个人签名为空哦 :)" : _userEntity.signature;
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
    if (section == 0 && row == 0) {
        UserProfileViewController *userProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile"
                                                                              bundle:[NSBundle mainBundle]]
                                                    instantiateViewControllerWithIdentifier:@"userprofile"];
        userProfileVC.userEntity = _userEntity;
        [self.navigationController pushViewController:userProfileVC animated:YES];
    } else if (section == 1 && row == 0) {
        NotificationListViewController *notificationListVC = [[NotificationListViewController alloc] init];
        notificationListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notificationListVC animated:YES];
    }
}

@end