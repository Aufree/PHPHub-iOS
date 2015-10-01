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
#import "UserModel.h"
#import "UserEntity.h"

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    LoginViewController *loginVC = [[UIStoryboard storyboardWithName:@"Passport" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:loginVC animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            UserEntity *user = [data objectForKey:@"entity"];
            NSURL *URL = [BaseHelper qiniuImageCenter:user.avatar withWidth:@"120" withHeight:@"120"];
            [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
            _usernameLabel.text = user.username;
            _userIntroLabel.text = [NSString isStringEmpty:user.signature] ? @"个人签名为空" : user.signature;
        }
    };
    
    [[UserModel Instance] getCurrentUserData:callback];
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
    
    if (section == 1 && row == 0) {
        NotificationListViewController *notificationListVC = [[NotificationListViewController alloc] init];
        notificationListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:notificationListVC animated:YES];
    }
}
@end
