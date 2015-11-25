//
//  TitlePagerView.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TitlePagerView.h"

static CGFloat TitlePagerViewTitleSpace = 50;

@interface TitlePagerView ()
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic, strong) UIImageView *pageIndicator;
@property (nonatomic, strong) NSArray *titleArray;
@end

@implementation TitlePagerView

- (id)init {
    self = [super init];
    if (self) {
        self.views = [NSMutableArray array];
        [self addSubview:self.pageIndicator];
    }
    return self;
}

- (void)addObjects:(NSArray *)objects {
    self.titleArray = objects;
    
    [self.views makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.views removeAllObjects];
    
    __weak typeof(self) weakself = self;
    
    [objects enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        if ([object isKindOfClass:[NSString class]]) {
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.text = object;
            textLabel.tag = idx;
            textLabel.textAlignment = NSTextAlignmentCenter;
            textLabel.font = self.font;
            textLabel.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapTextLabel = [[UITapGestureRecognizer alloc] initWithTarget:weakself action:@selector(didTapTextLabel:)];
            [textLabel addGestureRecognizer:tapTextLabel];
            
            [weakself addSubview:textLabel];
            [weakself.views addObject:textLabel];
            
        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.pageIndicator.y = self.height - 5;
    self.pageIndicator.width = (self.width - TitlePagerViewTitleSpace * (self.titleArray.count - 1))/self.titleArray.count;
    
    [self.views enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view sizeToFit];
        CGSize size = view.frame.size;
        size.width = self.width;
        CGFloat viewWidth = (size.width - TitlePagerViewTitleSpace * (self.titleArray.count - 1))/self.titleArray.count;
        view.frame = CGRectMake((viewWidth + TitlePagerViewTitleSpace) * idx, 0, viewWidth, size.height * 2);
    }];
}

- (void)didTapTextLabel:(UITapGestureRecognizer *)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTouchBWTitle:)]) {
        [self.delegate didTouchBWTitle:gestureRecognizer.view.tag];
    }
}

+ (CGFloat)calculateTitleWidth:(NSArray *)titleArray withFont:(UIFont *)titleFont {
    return [self getMaxTitleWidthFromArray:titleArray withFont:titleFont] * 3 + TitlePagerViewTitleSpace * 2;
}

+ (CGFloat)getMaxTitleWidthFromArray:(NSArray *)titleArray withFont:(UIFont *)titleFont {
    CGFloat maxWidth = 0;
    
    for (int i = 0; i < titleArray.count; i++) {
        NSString *titleString = [titleArray objectAtIndex:i];
        CGFloat titleWidth = [titleString sizeWithAttributes:@{NSFontAttributeName:titleFont}].width;
        if (titleWidth > maxWidth) {
            maxWidth = titleWidth;
        }
    }
    
    return maxWidth;
}

- (UIImageView *)pageIndicator {
    if (!_pageIndicator) {
        _pageIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 2)];
        _pageIndicator.image = [UIImage imageNamed:@"pager_title_indicator"];
        _pageIndicator.contentMode = UIViewContentModeScaleAspectFill;
        _pageIndicator.clipsToBounds = YES;
    }
    return _pageIndicator;
}

- (void)updatePageIndicatorPosition:(CGFloat)xPosition {
    CGFloat pageIndicatorXPosition = (((xPosition - SCREEN_WIDTH)/SCREEN_WIDTH) * (self.width - self.pageIndicator.width))/(self.titleArray.count - 1);
    self.pageIndicator.x = pageIndicatorXPosition;
}

- (void)adjustTitleViewByIndex:(CGFloat)index {
    for (UILabel *textLabel in self.subviews) {
        if ([textLabel isKindOfClass:[UILabel class]]) {
            textLabel.textColor = [UIColor colorWithWhite:0.675 alpha:1.000];
            if (textLabel.tag == index) {
                textLabel.textColor = [UIColor blackColor];
            }
        }
    }
    
    if (index == 0) {
        self.pageIndicator.x = 0;
    } else if (index == self.titleArray.count - 1) {
        self.pageIndicator.x = self.width - self.pageIndicator.width;
    }
}

@end
