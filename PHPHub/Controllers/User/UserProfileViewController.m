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
    _createdAtLabel.text = [NSString stringWithFormat:@"%@", _userEntity.createdAtDate];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *urlString;
    
    if (section == 3 && row == 0) {
        // Jump to GitHub
        urlString = [NSString stringWithFormat:@"%@%@", GitHubURL, _userEntity.githubName];
    } else if (section == 4 && row == 0) {
        // Jump to Twitter
        urlString = [NSString stringWithFormat:@"%@%@", TwitterURL, _userEntity.twitterAccount];
    } else if (section == 5 && row == 0) {
        // Jump to Blog
        urlString = _userEntity.blogURL;
    }
    
    if (![NSString isStringEmpty:urlString]) {
        TOWebViewController *webVC = [[TOWebViewController alloc] initWithURLString:urlString];
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
@end
