//
//  SkipButton.m
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "SkipButton.h"

@implementation SkipButton

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setupSkipButton];
    }
    return self;
}

- (void)setupSkipButton {
    self.width = 56;
    self.height = 30;
    
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.150];
    [self setTitle:@"Skip" forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:FontName size:14];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 7.5;
    self.layer.borderColor = [UIColor colorWithWhite:1.000 alpha:0.150].CGColor;
    self.layer.borderWidth = 1.5f;
    
}

@end
