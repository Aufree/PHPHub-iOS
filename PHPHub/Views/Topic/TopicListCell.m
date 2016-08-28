//
//  TopicListCell.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicListCell.h"
#import "BaseView.h"
#import "UserProfileViewController.h"

#import "Masonry.h"
#import "NSDate+DateTools.h"

static CGFloat topicListCellAvatarHeight = 38;

@interface TopicListCell ()
@property (nonatomic, strong) BaseView *baseView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *circleImageView;
@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *topicInfoLabel;
@property (nonatomic, strong) UILabel *topicRepliesCountLabel;
@property (nonatomic, assign) BOOL didSetupConstraints;
@end

@implementation TopicListCell

- (void)setTopicEntity:(TopicEntity *)topicEntity {
    _topicEntity = topicEntity;
    
    [self.contentView addSubview:self.baseView];
    
    NSURL *URL = [BaseHelper qiniuImageCenter:_topicEntity.user.avatar withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _topicTitleLabel.text = _topicEntity.topicTitle;
    _topicInfoLabel.text = [NSString stringWithFormat:@"%@ • 最后由 %@ • %@", _topicEntity.category.categoryName, _topicEntity.lastReplyUser.username, [_topicEntity.updatedAt timeAgoSinceNow]];
    NSNumber *repliesCount = _topicEntity.topicRepliesCount;
    _topicRepliesCountLabel.text = repliesCount.integerValue > 99 ? @"99+" : repliesCount.stringValue;
    
    if (!_didSetupConstraints) {
        self.didSetupConstraints = YES;
        [self addAutoLayoutToCell];
    }
}

- (BaseView *)baseView {
    if (!_baseView) {
        _baseView = [[BaseView alloc] init];
        
        [_baseView addSubview:self.avatarImageView];
        [_baseView addSubview:self.circleImageView];
        [_baseView addSubview:self.topicTitleLabel];
        [_baseView addSubview:self.topicInfoLabel];
        [_baseView addSubview:self.topicRepliesCountLabel];
    }
    return _baseView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, topicListCellAvatarHeight, topicListCellAvatarHeight)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAvatarImageView)];
        [_avatarImageView addGestureRecognizer:tapAvatar];
    }
    return _avatarImageView;
}

- (UIImageView *)circleImageView {
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, topicListCellAvatarHeight, topicListCellAvatarHeight)];
        _circleImageView.image = [UIImage imageNamed:@"corner_circle"];
    }
    return _circleImageView;
}

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [[UILabel alloc] init];
        _topicTitleLabel.font = [UIFont fontWithName:FontName size:14];
        _topicTitleLabel.numberOfLines = 2;
    }
    return _topicTitleLabel;
}

- (UILabel *)topicInfoLabel {
    if (!_topicInfoLabel) {
        _topicInfoLabel = [[UILabel alloc] init];
        _topicInfoLabel.height = 15;
        _topicInfoLabel.font = [UIFont fontWithName:FontName size:11];
        _topicInfoLabel.numberOfLines = 1;
        _topicInfoLabel.textColor = [UIColor colorWithWhite:0.773 alpha:1.000];
    }
    return _topicInfoLabel;
}

- (UILabel *)topicRepliesCountLabel {
    if (!_topicRepliesCountLabel) {
        _topicRepliesCountLabel = [[UILabel alloc] init];
        _topicRepliesCountLabel.font = [UIFont fontWithName:FontName size:11];
        _topicRepliesCountLabel.numberOfLines = 1;
        _topicRepliesCountLabel.textColor = [UIColor whiteColor];
        _topicRepliesCountLabel.textAlignment = NSTextAlignmentCenter;
        _topicRepliesCountLabel.backgroundColor = [UIColor clearColor];
        _topicRepliesCountLabel.layer.backgroundColor = [UIColor colorWithRed:0.392 green:0.702 blue:0.945 alpha:1.000].CGColor;
    }
    return _topicRepliesCountLabel;
}

- (void)addAutoLayoutToCell {
    CGFloat baseViewMargin = 8;
    CGFloat topicTitleMargin = 10;
    CGFloat topicTitleOffset = self.avatarImageView.width + topicTitleMargin * 2;
    
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView.mas_left).offset(baseViewMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-baseViewMargin);
        make.bottom.equalTo(self.contentView).offset(-baseViewMargin);
    }];
    
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_top).offset(topicTitleMargin);
        make.left.equalTo(self.baseView.mas_left).offset(topicTitleOffset);
        make.right.equalTo(self.topicRepliesCountLabel.mas_left).offset(-topicTitleMargin);
    }];
    
    [self.topicInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topicTitleLabel.mas_bottom).offset(baseViewMargin);
        make.left.equalTo(self.baseView.mas_left).offset(topicTitleOffset);
        make.right.equalTo(self.topicRepliesCountLabel.mas_left).offset(-topicTitleMargin);
        make.bottom.equalTo(self.baseView).offset(-topicTitleMargin);
    }];
    
    [self.topicRepliesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat topicRepliesCountHeight = 20;
        _topicRepliesCountLabel.layer.cornerRadius = topicRepliesCountHeight/2;
        _topicRepliesCountLabel.layer.shouldRasterize = YES;
        make.size.mas_equalTo(CGSizeMake(topicRepliesCountHeight, topicRepliesCountHeight));
        make.centerY.mas_equalTo(self.baseView.mas_centerY);
        make.right.equalTo(self.baseView).offset(-10);
    }];
}


#pragma mark Tap User Avatar

- (void)didTapAvatarImageView {
    UserProfileViewController *userProfileVC = [[UIStoryboard storyboardWithName:@"UserProfile"
                                                                          bundle:[NSBundle mainBundle]]
                                                instantiateViewControllerWithIdentifier:@"userprofile"];
    userProfileVC.userEntity = _topicEntity.user;
    [JumpToOtherVCHandler pushToOtherView:userProfileVC animated:YES];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([[gestureRecognizer view] isKindOfClass:[UITableViewCell class]]) {
        return NO;
    }
    return YES;
}

@end