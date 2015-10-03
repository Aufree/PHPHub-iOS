//
//  UserProfileViewController.m
//  PHPHub
//
//  Created by Aufree on 10/2/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TOWebViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userIntroLabel;
@property (weak, nonatomic) IBOutlet UILabel *localLabel;
@property (weak, nonatomic) IBOutlet UILabel *githubLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (weak, nonatomic) IBOutlet UILabel *blogLabel;
@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
    _avatarImageView.layer.masksToBounds = YES;
    
    [self updateUserProfileView];
    
    TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:@"http://baidu.com"];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)updateUserProfileView {
    NSString *avatarHeight = [NSString stringWithFormat:@"%.f", _avatarImageView.height * 2];
    NSURL *URL = [BaseHelper qiniuImageCenter:_userEntity.avatar withWidth:avatarHeight withHeight:avatarHeight];
    [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _usernameLabel.text = _userEntity.username;
    _realnameLabel.text = _userEntity.realName;
    _userIntroLabel.text = _userEntity.introduction;
    _localLabel.text = _userEntity.city;
    _githubLabel.text = _userEntity.githubName;
    _twitterLabel.text = _userEntity.twitterAccount;
    _blogLabel.text = _userEntity.githubURL;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
@end
