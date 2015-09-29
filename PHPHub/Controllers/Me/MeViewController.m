//
//  MeViewController.m
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "MeViewController.h"
#import "NotificationListViewController.h"
#import "PassportViewController.h"

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的";
    
    self.tableView.contentInset = UIEdgeInsetsMake(-1.0f, 0.0f, 0.0f, 0.0);
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    NSURL *URL = [BaseHelper qiniuImageCenter:@"http://7qncb1.com2.z0.glb.qiniucdn.com/uploads/users/avatar/0d20b07d7c08d8e15aea5238533ed5a6.jpg" withWidth:@"120" withHeight:@"120"];
    [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    
    PassportViewController *passportVC = [[UIStoryboard storyboardWithName:@"Passport" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"login"];
    [self.navigationController pushViewController:passportVC animated:NO];
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
