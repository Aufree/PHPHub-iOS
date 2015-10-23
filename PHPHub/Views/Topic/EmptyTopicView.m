//
//  EmptyTopicView.m
//  PHPHub
//
//  Created by Aufree on 10/23/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "EmptyTopicView.h"
#import "Masonry.h"

@interface EmptyTopicView ()
@property (nonatomic) UIView *containerView;
@property (nonatomic) UIImageView *emptyDataImage;
@property (nonatomic) UILabel *hintLabel;
@end

@implementation EmptyTopicView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setUp];
        [self addAutoLayout];
    }
    
    return self;
}

- (void)setUp {
    [self addSubview:self.containerView];
}

- (UIView *)containerView {
    if (_containerView == nil) {
        _containerView = [[UIView alloc] init];
        [_containerView addSubview:self.emptyDataImage];
        [_containerView addSubview:self.hintLabel];
    }
    return _containerView;
}

- (UIImageView *)emptyDataImage {
    if (_emptyDataImage == nil) {
        _emptyDataImage = [[UIImageView alloc] init];
        _emptyDataImage.image = [UIImage imageNamed:@"sad_face"];
    }
    return _emptyDataImage;
}

- (UILabel *)hintLabel {
    if (_hintLabel == nil) {
        _hintLabel = [[UILabel alloc] init];
        _hintLabel.font = [UIFont fontWithName:FontName size:18];
        _hintLabel.textColor = [UIColor colorWithWhite:0.620 alpha:1.000];
        _hintLabel.textAlignment = NSTextAlignmentCenter;
        _hintLabel.text = @"暂无数据";
    }
    return _hintLabel;
}

- (void)addAutoLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 230));
    }];
    
    [self.emptyDataImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(140, 140));
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyDataImage.mas_bottom).offset(30);
        make.centerX.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 20));
    }];
}

@end
