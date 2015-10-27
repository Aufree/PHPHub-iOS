//
//  SettingsViewController.m
//  PHPHub
//
//  Created by Aufree on 10/4/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "SettingsViewController.h"
#import "TOWebViewController.h"

#import "UMFeedback.h"
#import "WCAlertView.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 100.0f : 0.1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    UIViewController *vc;
    
    if (section == 0) {
        [self jumpToUMFeedBack];
    } else if (section == 1) {
        switch (row) {
            case 0:
                vc = [[TOWebViewController alloc] initWithURLString:ProjectURL];
                break;
            case 1:
                vc = [[TOWebViewController alloc] initWithURLString:AboutTheAuthorURL];
                break;
            case 2:
                vc = [[TOWebViewController alloc] initWithURLString:AboutPageURL];
                break;
            case 3:
                vc = [[TOWebViewController alloc] initWithURLString:ESTGroupURL];
                break;
        }
    } else if (section == 2) {
        [self showLogoutAlertView];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)jumpToUMFeedBack {
    UserEntity *currentUser = [[CurrentUser Instance] userInfo];
    NSString *plain = [NSString stringWithFormat:@"uid:%@ - uname:%@", currentUser.userId, currentUser.username];
    [[UMFeedback sharedInstance] updateUserInfo:@{@"contact":
                                                   @{
                                                      @"email": currentUser.email,
                                                      @"phone": @"",
                                                      @"qq": @"",
                                                      @"plain": plain
                                                    }
                                                  }];
    [self presentViewController:[UMFeedback feedbackModalViewController] animated:YES completion:nil];
}

- (void)showLogoutAlertView {
    __weak typeof(self) weakSelf = self;
    [WCAlertView showAlertWithTitle:@"提示" message:@"您确定要退出当前账号吗?" customizationBlock:nil completionBlock:
     ^(NSUInteger buttonIndex, WCAlertView *alertView) {
         if (buttonIndex == 1) {
             [AnalyticsHandler logEvent:@"退出登录" withCategory:kUserAction label:[CurrentUser Instance].userLabel];
             [weakSelf logout];
         }
     } cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
}

- (void)logout {
    [[CurrentUser Instance] logOut];    
    [self.navigationController popViewControllerAnimated:YES];
}

@end