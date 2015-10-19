//
//  NotificationListCell.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationListCell.h"
#import "UserProfileViewController.h"
#import "BaseView.h"

#import "Masonry.h"
#import "NSDate+DateTools.h"

static CGFloat notificationListCellAvatarHeight = 38;
static CGFloat notificationListCellTitleHeight = 15;
static CGFloat notificationListCellTitleMarginTop = 10;
static CGFloat notificationListCellContentFontSize = 13;

@interface NotificationListCell ()
@property (nonatomic, strong) BaseView *baseView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UILabel *notificationInfoLabel;
@property (nonatomic, strong) UILabel *notificationContentLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation NotificationListCell

- (void)setNotificationEntity:(NotificationEntity *)notificationEntity {
    _notificationEntity = notificationEntity;
    
    [self.contentView addSubview:self.baseView];
    NSURL *URL = [BaseHelper qiniuImageCenter:notificationEntity.fromUser.avatar withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _notificationInfoLabel.text = [NSString stringWithFormat:@"%@ • %@", _notificationEntity.fromUser.username, [_notificationEntity.createdAt timeAgoSinceNow]];
    _notificationContentLabel.text = notificationEntity.message;
    
    if (!_didSetupConstraints) {
        self.didSetupConstraints = YES;
        [self addAutoLayoutToCell];
    }
}

- (BaseView *)baseView {
    if (!_baseView) {
        _baseView = [[BaseView alloc] init];
        [_baseView addSubview:self.avatarImageView];
        [_baseView addSubview:self.notificationInfoLabel];
        [_baseView addSubview:self.notificationContentLabel];
    }
    return _baseView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, notificationListCellAvatarHeight, notificationListCellAvatarHeight)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatarImageView)];
        [_avatarImageView addGestureRecognizer:tapAvatar];
        [_avatarImageView addSubview:self.circleImageView];
    }
    return _avatarImageView;
}

- (UIImageView *)circleImageView {
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _avatarImageView.width, _avatarImageView.height)];
        _circleImageView.image = [UIImage imageNamed:@"corner_circle"];
    }
    return _circleImageView;
}

- (UILabel *)notificationInfoLabel {
    if (!_notificationInfoLabel) {
        _notificationInfoLabel = [[UILabel alloc] init];
        _notificationInfoLabel.textColor = [UIColor colorWithWhite:0.773 alpha:1.000];
        _notificationInfoLabel.font = [UIFont fontWithName:FontName size:11];
    }
    return _notificationInfoLabel;
}

- (UILabel *)notificationContentLabel {
    if (!_notificationContentLabel) {
        _notificationContentLabel = [[UILabel alloc] init];
        _notificationContentLabel.textColor = [UIColor colorWithWhite:0.267 alpha:1.000];
        _notificationContentLabel.font = [UIFont fontWithName:FontName size:notificationListCellContentFontSize];
        _notificationContentLabel.numberOfLines = 0;
    }
    return _notificationContentLabel;
}

- (void)addAutoLayoutToCell {
    CGFloat baseViewMargin = 8;
    CGFloat infoMargin = notificationListCellTitleMarginTop;
    CGFloat marginLeft = self.avatarImageView.width + infoMargin * 2;
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(baseViewMargin);
        make.left.equalTo(self.contentView.mas_left).offset(baseViewMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-baseViewMargin);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
    }];
    
    [self.notificationInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_top).offset(infoMargin);
        make.left.equalTo(self.baseView.mas_left).offset(marginLeft);
        make.right.equalTo(self.baseView.mas_right).offset(-baseViewMargin);
        make.height.mas_equalTo(notificationListCellTitleHeight);
    }];

    [self.notificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.notificationInfoLabel.mas_bottom).offset(infoMargin/2);
        make.left.equalTo(self.baseView.mas_left).offset(marginLeft);
        make.right.equalTo(self.baseView.mas_right).offset(-baseViewMargin);
        make.bottom.equalTo(self.baseView.mas_bottom).offset(-12);
    }];
}

#pragma mark Tap User Avatar

- (void)didTapAvatarImageView {
    UserProfileViewController *userProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile"
                                                                          bundle:[NSBundle mainBundle]]
                                                instantiateViewControllerWithIdentifier:@"userprofile"];
    userProfileVC.userEntity = _notificationEntity.fromUser;
    [JumpToOtherVCHandler pushToOtherView:userProfileVC animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([[gestureRecognizer view] isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}

@end
