//
//  TopicListCell.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicListCell.h"
#import "Masonry.h"

static CGFloat topicListCellAvatarHeight = 38;

@interface TopicListCell ()
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *topicTitleLabel;
@property (nonatomic, strong) UILabel *topicInfoLabel;
@property (nonatomic, strong) UILabel *topicRepliesCountLabel;
@end

@implementation TopicListCell

- (void)setTopicEntity:(TopicEntity *)topicEntity {
    _topicEntity = topicEntity;
    
    [self.contentView addSubview:self.baseView];
    
    NSURL *URL = [BaseHelper qiniuImageCenter:_topicEntity.user.userAvatar withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:URL];
    _topicTitleLabel.text = _topicEntity.topicTitle;
    _topicInfoLabel.text = @"安全 • 最后由 Aufree • 5天前";
    _topicRepliesCountLabel.text = _topicEntity.topicRepliesCount.stringValue;
    
    [self addAutoLayoutToCell];
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] init];
        _baseView.backgroundColor = [UIColor clearColor];
        _baseView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        _baseView.layer.cornerRadius = 2;
        _baseView.layer.borderColor = [UIColor colorWithRed:0.871 green:0.875 blue:0.878 alpha:1.000].CGColor;
        _baseView.layer.borderWidth = 0.5;
        
        [_baseView addSubview:self.avatarImageView];
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
        _avatarImageView.backgroundColor = [UIColor clearColor];
        _avatarImageView.layer.backgroundColor = [UIColor colorWithRed:0.176 green:0.600 blue:0.953 alpha:0.340].CGColor;
        _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [[UILabel alloc] init];
        _topicTitleLabel.font = [UIFont fontWithName:FontName size:14];
        _topicTitleLabel.numberOfLines = 1;
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
        make.top.offset(baseViewMargin);
        make.left.equalTo(self.contentView.mas_left).offset(baseViewMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-baseViewMargin);
        make.bottom.offset(0);
    }];
    
    [self.topicTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_top).offset(topicTitleMargin);
        make.left.equalTo(self.baseView.mas_left).offset(topicTitleOffset);
        make.right.equalTo(self.topicRepliesCountLabel.mas_left).offset(-topicTitleMargin);
    }];
    
    [self.topicInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_bottom).offset(-topicTitleMargin - self.topicInfoLabel.height);
        make.left.equalTo(self.baseView.mas_left).offset(topicTitleOffset);
        make.right.equalTo(self.topicRepliesCountLabel.mas_left).offset(-topicTitleMargin);
        make.height.mas_equalTo(self.topicInfoLabel.height);
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
@end