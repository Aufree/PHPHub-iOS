//
//  UserProfileViewController.m
//  PHPHub
//
//  Created by Aufree on 10/2/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}
@end
