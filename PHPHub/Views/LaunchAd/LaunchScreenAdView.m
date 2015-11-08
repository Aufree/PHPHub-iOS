//
//  LaunchScreenAdView.m
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "LaunchScreenAdView.h"
#import "LaunchScreenAdHandler.h"

#if !__has_feature(objc_arc)
#error LaunchScreenAdView requires ARC enabled. Mark the .m file with the objc_arc linker flag.
#endif

@interface LaunchScreenAdView () {
    BOOL _animating;
    NSUInteger _totalImages;
    NSUInteger _currentlyDisplayingImageViewIndex;
    NSInteger _currentlyDisplayingImageIndex;
    NSUInteger _currentTime;
}
@property (nonatomic, strong) SkipButton *skipButton;
@end

@implementation LaunchScreenAdView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    [self addSubview:self.imageView];
    [self addSubview:self.durationTimeLabel];
    [self addSubview:self.skipButton];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleClickedEvent)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:recognizer];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)durationTimeLabel {
    if (!_durationTimeLabel) {
        _durationTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 40, 23, 30, 30)];
        _durationTimeLabel.font = [UIFont fontWithName:FontName size:15];
        _durationTimeLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.150];
        _durationTimeLabel.textColor = [UIColor whiteColor];
        _durationTimeLabel.textAlignment = NSTextAlignmentCenter;
        _durationTimeLabel.layer.cornerRadius = 5;
        _durationTimeLabel.layer.masksToBounds = YES;
        _durationTimeLabel.layer.borderColor = [UIColor colorWithWhite:1.000 alpha:0.150].CGColor;
        _durationTimeLabel.layer.borderWidth = .5f;
    }
    return _durationTimeLabel;
}

- (SkipButton *)skipButton {
    if (!_skipButton) {
        _skipButton = [[SkipButton alloc] init];
        _skipButton.x = SCREEN_WIDTH - 18 - _skipButton.width;
        _skipButton.y = SCREEN_HEIGHT - 25 - _skipButton.height;
        [_skipButton addTarget:self action:@selector(didTouchSkipButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

#pragma mark - Animations

- (void)startAnimateWithImageLink:(NSURL *)url
{
    [self.imageView sd_setImageWithURL:url];
    self.updateDurationLabelTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateDurationTimeLabel) userInfo:nil repeats:YES];
    _currentTime = self.transitionDuration;
}

- (void)updateDurationTimeLabel {
    _currentTime -= 1;
    _durationTimeLabel.text = [NSString stringWithFormat:@"%lus", (unsigned long)_currentTime];
    if (_currentTime == 0) {
        [LaunchScreenAdHandler removeLaunchScreenAd:NO];
        [self invalidDurationTimer];
    }
}

- (void)invalidDurationTimer {
    if ([_updateDurationLabelTimer isValid]) {
        [_updateDurationLabelTimer invalidate];
    }
    _updateDurationLabelTimer = nil;
}

#pragma mark - Handler Event

- (void)handleClickedEvent {
    [LaunchScreenAdHandler removeLaunchScreenAd:YES];
    [self invalidDurationTimer];
}

- (void)didTouchSkipButton {
    [LaunchScreenAdHandler removeLaunchScreenAd:NO];
    [self invalidDurationTimer];
}

@end
