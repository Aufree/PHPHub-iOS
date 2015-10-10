//
//  TopicVoteView.m
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "TopicVoteView.h"
#import "Masonry.h"

static CGFloat VoteContainerViewWidth = 240;
static CGFloat VoteContainerViewHeight = 110;
@interface TopicVoteView ()
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *voteContainerView;
@end

@implementation TopicVoteView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self addSubview:self.maskView];
    [self addConstraintToVoteView];
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:self.bounds];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.847 alpha:0.600];
        _maskView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapMaskView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewDidTouch)];
        [_maskView addGestureRecognizer:tapMaskView];
        [_maskView addSubview:self.voteContainerView];
    }
    return _maskView;
}

- (UIView *)voteContainerView {
    if (!_voteContainerView) {
        _voteContainerView = [[UIView alloc] init];
        _voteContainerView.backgroundColor = [UIColor whiteColor];
        _voteContainerView.layer.cornerRadius = 5.0f;
        [_voteContainerView addSubview:self.upVoteButton];
        [_voteContainerView addSubview:self.downVoteButton];
    }
    return _voteContainerView;
}

- (UIButton *)upVoteButton {
    if (!_upVoteButton) {
        _upVoteButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, VoteContainerViewWidth/2, VoteContainerViewHeight)];
        [_upVoteButton setImage:[UIImage imageNamed:@"big_upvote_icon"] forState:UIControlStateNormal];
        [_upVoteButton setImage:[UIImage imageNamed:@"big_upvote_selected_icon"] forState:UIControlStateHighlighted];
    }
    return _upVoteButton;
}

- (UIButton *)downVoteButton {
    if (!_downVoteButton) {
        _downVoteButton = [[UIButton alloc] initWithFrame:CGRectMake(VoteContainerViewWidth/2, 0, VoteContainerViewWidth/2, VoteContainerViewHeight)];
        [_downVoteButton setImage:[UIImage imageNamed:@"big_downvote_icon"] forState:UIControlStateNormal];
        [_downVoteButton setImage:[UIImage imageNamed:@"big_downvote_selected_icon"] forState:UIControlStateHighlighted];
    }
    return _downVoteButton;
}

- (void)addConstraintToVoteView {
    [_voteContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(VoteContainerViewWidth, VoteContainerViewHeight));
        make.centerX.mas_equalTo(self.maskView.mas_centerX);
        make.centerY.mas_equalTo(self.maskView.mas_centerY);
    }];
}

- (void)maskViewDidTouch {
    [self removeFromSuperview];
}
@end
