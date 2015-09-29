//
//  NotificationListCell.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationListCell.h"
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
@end

@implementation NotificationListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setNotificationEntity:(NotificationEntity *)notificationEntity {
    _notificationEntity = notificationEntity;
    
    [self.contentView addSubview:self.baseView];
    NSURL *URL = [BaseHelper qiniuImageCenter:notificationEntity.user.userAvatar withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _notificationInfoLabel.text = @"Aufree • 4天前";
    _notificationContentLabel.text = notificationEntity.notificationContent;
    
    [self addAutoLayoutToCell];
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
        make.top.offset(baseViewMargin);
        make.left.equalTo(self.contentView.mas_left).offset(baseViewMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-baseViewMargin);
        make.bottom.offset(0);
    }];
    
    [self.notificationInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_top).offset(infoMargin);
        make.left.equalTo(self.baseView.mas_left).offset(marginLeft);
        make.right.equalTo(self.baseView.mas_right).offset(-infoMargin/2);
        make.height.mas_equalTo(notificationListCellTitleHeight);
    }];

    [self.notificationContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.notificationInfoLabel.mas_bottom).offset(infoMargin/2);
        make.left.equalTo(self.baseView.mas_left).offset(marginLeft);
        make.right.equalTo(self.baseView.mas_right).offset(-infoMargin/2);
    }];
}

+ (CGFloat)countHeightForCell:(NotificationEntity *)notificationEntity {
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:notificationEntity.notificationContent
                                                                                      attributes:@{NSFontAttributeName:[UIFont fontWithName:FontName
                                                                                                                                       size:notificationListCellContentFontSize]}];
    
    CGFloat contentMarginLeft = notificationListCellAvatarHeight + 20;
    CGFloat contentMarginRight = 5;
    CGFloat maxWidth = SCREEN_WIDTH - (contentMarginLeft + contentMarginRight);
    
    CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    
    return notificationListCellTitleHeight + notificationListCellTitleMarginTop * 3 + rect.size.height;
}
@end
