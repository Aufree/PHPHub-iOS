//
//  LaunchScreenAdView.h
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkipButton.h"

@interface LaunchScreenAdView : UIView
@property (nonatomic, assign) NSTimeInterval timePerImage;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSTimeInterval transitionDuration;
@property (nonatomic, strong) UILabel *durationTimeLabel;
@property (nonatomic) NSTimer *updateDurationLabelTimer;
- (void)startAnimateWithImageLink:(NSURL *)url;
@end