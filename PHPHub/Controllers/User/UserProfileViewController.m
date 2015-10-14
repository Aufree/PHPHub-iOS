//
//  UserProfileViewController.m
//  PHPHub
//
//  Created by Aufree on 10/2/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TOWebViewController.h"
#import "TopicListViewController.h"
#import "EditUserProfileViewController.h"

@interface UserProfileViewController () <EditUserProfileViewControllerDelegate>
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
    
    NSNumber *currentUserId = [CurrentUser Instance].userId;
    if (currentUserId && [_userEntity.userId isEqualToNumber:currentUserId]) {
        [self createRightButtonItem];
        _userEntity = [[CurrentUser Instance] userInfo];
        [self updateUserProfileView];
    } else {
        __weak typeof(self) weakself = self;
        BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
            if (!error) {
                _userEntity = data[@"entity"];
                [weakself updateUserProfileView];
            }
        };
        
        [[UserModel Instance] getUserById:_userEntity.userId callback:callback];
    }
}

- (void)updateUserProfileView {
    NSString *avatarHeight = [NSString stringWithFormat:@"%.f", _avatarImageView.height * 2];
    NSURL *URL = [BaseHelper qiniuImageCenter:_userEntity.avatar withWidth:avatarHeight withHeight:avatarHeight];
    [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _usernameLabel.text = _userEntity.username;
    _realnameLabel.text = _userEntity.realName;
    _userIntroLabel.text = _userEntity.signature;
    _localLabel.text = _userEntity.city;
    _githubLabel.text = _userEntity.githubName;
    _twitterLabel.text = _userEntity.twitterAccount;
    _blogLabel.text = _userEntity.blogURL;
    _createdAtLabel.text = [NSString stringWithFormat:@"%@", _userEntity.createdAtDate];
}

- (void)refreshUserProfileView {
    _userEntity = [[CurrentUser Instance] userInfo];
    [self updateUserProfileView];
}

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"edit_profile_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(jumpToEditUserProfile)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)jumpToEditUserProfile {
    EditUserProfileViewController *editUserProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile"
                                                                                  bundle:[NSBundle mainBundle]]
                                                        instantiateViewControllerWithIdentifier:@"edituserprofile"];
    editUserProfileVC.delegate = self;
    [self.navigationController pushViewController:editUserProfileVC animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    NSString *urlString;
    UIViewController *vc;
    
    if (section == 3 && row == 0) {
        // Jump to GitHub
        urlString = [NSString stringWithFormat:@"%@%@", GitHubURL, _userEntity.githubName];
    } else if (section == 4 && row == 0) {
        // Jump to Twitter
        urlString = [NSString stringWithFormat:@"%@%@", TwitterURL, _userEntity.twitterAccount];
    } else if (section == 5 && row == 0) {
        // Jump to Blog
        urlString = _userEntity.blogURL;
    } else if (section == 6) {
        switch (row) {
            case 0:
                vc = [self createTopicListWithType:TopicListTypeNormal];
                break;
            case 1:
                vc = [[TOWebViewController alloc] initWithURLString:_userEntity.repliesUrl];
                break;
            case 2:
                vc = [self createTopicListWithType:TopicListTypeAttention];
                break;
            case 3:
                vc = [self createTopicListWithType:TopicListTypeFavorite];
                break;
                
            default:
                break;
        }
    }
    
    if (![NSString isStringEmpty:urlString]) {
        vc = [[TOWebViewController alloc] initWithURLString:urlString];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (TopicListViewController *)createTopicListWithType:(TopicListType)topicListType {
    TopicListViewController *topicListVC = [[TopicListViewController alloc] init];
    topicListVC.userId = _userEntity.userId.integerValue;
    topicListVC.topicListType = topicListType;
    return topicListVC;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
@end
