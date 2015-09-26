//
//  NotificationListCell.m
//  PHPHub
//
//  Created by Aufree on 9/26/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NotificationListCell.h"
#import "BaseView.h"

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

- (void)setContent:(NSString *)content {
    _content = content;
    
    [self.contentView addSubview:self.baseView];
    NSURL *URL = [BaseHelper qiniuImageCenter:@"" withWidth:@"76" withHeight:@"76"];
    [_avatarImageView sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"avatar_placeholder"]];
    _notificationInfoLabel.text = @"goodspb • 4天前";
    _notificationContentLabel.text = _content;
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
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_avatarImageView addSubview:self.circleImageView];
    }
    return _avatarImageView;
}

- (UIImageView *)circleImageView {
    if (!_circleImageView) {
        _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 38, 38)];
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
        _notificationContentLabel.font = [UIFont fontWithName:FontName size:13];
    }
    return _notificationContentLabel;
}

@end
