//
//  TopicListCell.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicListCell.h"

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
    _topicInfoLabel.text = @"安全 • 最后由 fvzone • 4天前";
    _topicRepliesCountLabel.text = _topicEntity.topicRepliesCount.stringValue;
}

- (UIView *)baseView {
    if (!_baseView) {
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, 57)];
        _baseView.backgroundColor = [UIColor whiteColor];
        _baseView.layer.cornerRadius = 2;
        _baseView.layer.masksToBounds = YES;
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
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 38)];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarImageView.backgroundColor = [UIColor colorWithRed:0.175 green:0.600 blue:0.953 alpha:0.340];
        _avatarImageView.layer.cornerRadius = _avatarImageView.height/2;
        _avatarImageView.layer.masksToBounds = YES;
    }
    return _avatarImageView;
}

- (UILabel *)topicTitleLabel {
    if (!_topicTitleLabel) {
        _topicTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, 10, self.baseView.width - 58 - 40, 17)];
        _topicTitleLabel.font = [UIFont fontWithName:FontName size:14];
        _topicTitleLabel.numberOfLines = 1;
    }
    return _topicTitleLabel;
}

- (UILabel *)topicInfoLabel {
    if (!_topicInfoLabel) {
        _topicInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(58, self.contentView.height - 10, self.baseView.width - 58 - 40, 15)];
        _topicInfoLabel.font = [UIFont fontWithName:FontName size:11];
        _topicInfoLabel.numberOfLines = 1;
        _topicInfoLabel.textColor = [UIColor colorWithWhite:0.773 alpha:1.000];
    }
    return _topicInfoLabel;
}

- (UILabel *)topicRepliesCountLabel {
    if (!_topicRepliesCountLabel) {
        _topicRepliesCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.baseView.width - 30, (self.baseView.height - 20)/2, 20, 20)];
        _topicRepliesCountLabel.font = [UIFont fontWithName:FontName size:11];
        _topicRepliesCountLabel.numberOfLines = 1;
        _topicRepliesCountLabel.textColor = [UIColor whiteColor];
        _topicRepliesCountLabel.backgroundColor = [UIColor colorWithRed:0.392 green:0.702 blue:0.945 alpha:1.000];
        _topicRepliesCountLabel.textAlignment = NSTextAlignmentCenter;
        _topicRepliesCountLabel.layer.cornerRadius = _topicRepliesCountLabel.height/2;
        _topicRepliesCountLabel.layer.masksToBounds = YES;
    }
    return _topicRepliesCountLabel;
}
@end
