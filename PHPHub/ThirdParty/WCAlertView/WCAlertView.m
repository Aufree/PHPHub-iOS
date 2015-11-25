//
//  WCAlertView.m
//  WCAlertView
//
//  Created by Michał Zaborowski on 18/07/12.
//  Copyright (c) 2012 Michał Zaborowski. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "WCAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface WCAlertView () <UIAlertViewDelegate>

@end

@implementation WCAlertView
@synthesize buttonShadowColor = _buttonShadowColor;
@synthesize buttonShadowOffset = _buttonShadowOffset;
@synthesize buttonTextColor = _buttonTextColor;
@synthesize verticalLineColor = _verticalLineColor;
@synthesize innerFrameShadowColor = _innerFrameShadowColor;
@synthesize hatchedLinesColor = _hatchedLinesColor;
@synthesize outerFrameColor = _outerFrameColor;
@synthesize hatchedBackgroundColor = _hatchedBackgroundColor;
@synthesize style = _style;
@synthesize buttonShadowBlur = _buttonShadowBlur;
@synthesize buttonFont = _buttonFont;


static WCAlertViewStyle kDefaultAlertStyle = WCAlertViewStyleDefault;

+ (void)setDefaultStyle:(WCAlertViewStyle)style {
    
    kDefaultAlertStyle = style;
    
}

+ (id)showAlertWithTitle:(NSString *)title message:(NSString *)message customizationBlock:(void (^)(WCAlertView *alertView))customization completionBlock:(void (^)(NSUInteger buttonIndex, WCAlertView *alertView))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {

    WCAlertView *alertView = [[self alloc] initWithTitle:title message:message completionBlock:block cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    
    if (otherButtonTitles != nil) {
        id eachObject;
        va_list argumentList;
        if (otherButtonTitles) {
            [alertView addButtonWithTitle:otherButtonTitles];
            va_start(argumentList, otherButtonTitles);
            while ((eachObject = va_arg(argumentList, id))) {
                [alertView addButtonWithTitle:eachObject];
            }
            va_end(argumentList);
        }
    }
    
    if (customization) {
        customization(alertView);
    }
    
    [alertView show];
    
    return alertView;
    
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil]) {
        
        [self setDefaultStyle];
        
        va_list args;
        va_start(args, otherButtonTitles);
        for (NSString *anOtherButtonTitle = otherButtonTitles; anOtherButtonTitle != nil; anOtherButtonTitle = va_arg(args, NSString*)) {
            [self addButtonWithTitle:anOtherButtonTitle];
        }
    }
    return self;
}


- (id)initWithTitle:(NSString *)title message:(NSString *)message completionBlock:(void (^)(NSUInteger buttonIndex, WCAlertView *alertView))block cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
	objc_setAssociatedObject(self, "blockCallback", [block copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	
	if (self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil]) {
        
		
		if (cancelButtonTitle) {
			[self addButtonWithTitle:cancelButtonTitle];
			self.cancelButtonIndex = [self numberOfButtons] - 1;
		}
		
		id eachObject;
		va_list argumentList;
		if (otherButtonTitles) {
			[self addButtonWithTitle:otherButtonTitles];
			va_start(argumentList, otherButtonTitles);
			while ((eachObject = va_arg(argumentList, id))) {
				[self addButtonWithTitle:eachObject];
			}
			va_end(argumentList);
		}
	}
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	void (^block)(NSUInteger buttonIndex, UIAlertView *alertView) = objc_getAssociatedObject(self, "blockCallback");
    if (block) {
        block(buttonIndex, self);
    }
	
}

- (void)setStyle:(WCAlertViewStyle)style {
    if (style != _style) {
        _style = style;
        [self customizeAlertViewStyle:style];
    }
}

- (void)setDefaultStyle {
    self.buttonShadowBlur = 2.0f;
    self.buttonShadowOffset = CGSizeMake(0.5f, 0.5f);
    self.labelShadowOffset = CGSizeMake(0.0f, 1.0f);
    self.gradientLocations = @[ @0.0f, @0.57f, @1.0f];
    self.cornerRadius = 10.0f;
    self.labelTextColor = [UIColor whiteColor];
    self.outerFrameLineWidth = 2.0f;
    self.outerFrameShadowBlur = 6.0f;
    self.outerFrameShadowColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f];
    self.outerFrameShadowOffset = CGSizeMake(0.0f, 1.0f);
    self.style = kDefaultAlertStyle;
    
}

- (void)customizeAlertViewStyle:(WCAlertViewStyle)style {
    switch (style) {
        case WCAlertViewStyleDefault:
            break;
        case WCAlertViewStyleWhite:
            [self whiteAlertHatched:NO];
            break;
        case WCAlertViewStyleWhiteHatched:
            [self whiteAlertHatched:YES];
            break;
        case WCAlertViewStyleBlack:
            [self blackAlertHatched:NO];
            break;
        case WCAlertViewStyleBlackHatched:
            [self blackAlertHatched:YES];
            break;
        case WCAlertViewStyleViolet:
            [self violetAlertHetched:NO];
            break;
        case WCAlertViewStyleVioletHatched:
            [self violetAlertHetched:YES];
            break;
        default:
            self.style = kDefaultAlertStyle;
            break;
    }
}

- (void)violetAlertHetched:(BOOL)hatched {
    self.labelTextColor = [UIColor whiteColor];
    self.labelShadowColor = [UIColor colorWithRed:0.004 green:0.003 blue:0.006 alpha:0.700];
    
    UIColor *topGradient = [UIColor colorWithRed:0.66f green:0.63f blue:1.00f alpha:1.00f];
    UIColor *middleGradient = [UIColor colorWithRed:0.508 green:0.498 blue:0.812 alpha:1.000];
    UIColor *bottomGradient = [UIColor colorWithRed:0.419 green:0.405 blue:0.654 alpha:1.000];
    self.gradientColors = @[topGradient,middleGradient,bottomGradient];
    
    self.outerFrameColor = [UIColor whiteColor];
    self.innerFrameStrokeColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.41f alpha:1.00f];
    self.innerFrameShadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    
    self.buttonTextColor = [UIColor whiteColor];
    self.buttonShadowBlur = 2.0;
    self.buttonShadowColor = [UIColor colorWithRed:0.004 green:0.003 blue:0.006 alpha:1.000];
    
    
    if (hatched) {
        self.outerFrameColor = [UIColor colorWithRed:0.25f green:0.25f blue:0.41f alpha:1.00f];
        self.outerFrameShadowOffset = CGSizeMake(0.0, 0.0);
        self.outerFrameShadowBlur = 0.0;
        self.outerFrameShadowColor = [UIColor clearColor];
        self.outerFrameLineWidth = 0.5f;
        self.verticalLineColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
        self.hatchedLinesColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    }
}

- (void)whiteAlertHatched:(BOOL)hatched {
    self.labelTextColor = [UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    self.labelShadowColor = [UIColor whiteColor];
    
    UIColor *topGradient = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    UIColor *middleGradient = [UIColor colorWithRed:0.93f green:0.94f blue:0.96f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:0.89f green:0.89f blue:0.92f alpha:1.00f];
    self.gradientColors = @[topGradient,middleGradient,bottomGradient];
    
    self.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    
    self.buttonTextColor = [UIColor colorWithRed:0.11f green:0.08f blue:0.39f alpha:1.00f];
    self.buttonShadowColor = [UIColor whiteColor];
    
    if (hatched) {
        self.verticalLineColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
        self.hatchedLinesColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1];
    }
}

- (void)blackAlertHatched:(BOOL)hatched {
    self.labelTextColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    self.labelShadowColor = [UIColor blackColor];
    self.labelShadowOffset = CGSizeMake(0.0f, 1.0f);
    
    UIColor *topGradient = [UIColor colorWithRed:0.27f green:0.27f blue:0.27f alpha:1.0f];
    UIColor *middleGradient = [UIColor colorWithRed:0.21f green:0.21f blue:0.21f alpha:1.0f];
    UIColor *bottomGradient = [UIColor colorWithRed:0.15f green:0.15f blue:0.15f alpha:1.00f];
    self.gradientColors = @[topGradient,middleGradient,bottomGradient];
    
    self.outerFrameColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    
    self.buttonTextColor = [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f];
    self.buttonShadowColor = [UIColor blackColor];
    
    if (hatched) {
        self.verticalLineColor = [UIColor blackColor];
        self.innerFrameShadowColor = [UIColor blackColor];
        self.hatchedLinesColor = [UIColor blackColor];
    }
    
}

#pragma mark -
#pragma mark UIView Overrides
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.style) {
        for (UIView *subview in self.subviews){
            
            //Find and hide UIImageView Containing Blue Background
            if ([subview isMemberOfClass:[UIImageView class]]) {
                subview.hidden = YES; 
            }
            
            //Find and get styles of UILabels
            if ([subview isMemberOfClass:[UILabel class]]) {
                UILabel *label = (UILabel*)subview;	
                label.textColor = self.labelTextColor;
                label.shadowColor = self.labelShadowColor;
                label.shadowOffset = self.labelShadowOffset;
            }
            
            // Hide button title labels
            if ([subview isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)subview;
                button.titleLabel.alpha = 0;
            }
        }
    }
    
}

- (void)drawRect:(CGRect)rect  {
    [super drawRect:rect];
    
    if (self.style) {
        
        /*
         *  Current graphics context
         */
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        /*
         *  Create base shape with rounded corners from bounds
         */
        
        CGRect activeBounds = self.bounds;
        CGFloat cornerRadius = self.cornerRadius;
        CGFloat inset = 5.5f;
        CGFloat originX = activeBounds.origin.x + inset;
        CGFloat originY = activeBounds.origin.y + inset;
        CGFloat width = activeBounds.size.width - (inset*2.0f);
        CGFloat height = activeBounds.size.height - ((inset+2.0)*2.0f);
        
        CGFloat buttonOffset = self.bounds.size.height - 50.5f;
        
        CGRect bPathFrame = CGRectMake(originX, originY, width, height);
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:bPathFrame cornerRadius:cornerRadius].CGPath;
        
        /*
         *  Create base shape with fill and shadow
         */
        
        CGContextAddPath(context, path);
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
        CGContextSetShadowWithColor(context, self.outerFrameShadowOffset, self.outerFrameShadowBlur, self.outerFrameShadowColor.CGColor);
        CGContextDrawPath(context, kCGPathFill);
        
        /*
         *  Clip state
         */
        
        CGContextSaveGState(context); //Save Context State Before Clipping To "path"
        CGContextAddPath(context, path);
        CGContextClip(context);
        
        //////////////DRAW GRADIENT
        /*
         *  Draw grafient from gradientLocations
         */
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        size_t count = [self.gradientLocations count];
        
        CGFloat *locations = malloc(count * sizeof(CGFloat));
        [self.gradientLocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            locations[idx] = [((NSNumber *)obj) floatValue];
        }];
        
        CGFloat *components = malloc([self.gradientColors count] * 4 * sizeof(CGFloat));
        
        [self.gradientColors enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIColor *color = (UIColor *)obj;
            
            NSInteger startIndex = (idx * 4);
            
            [color getRed:&components[startIndex]
                    green:&components[startIndex+1]
                     blue:&components[startIndex+2]
                    alpha:&components[startIndex+3]];
        }];
        
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
        
        CGPoint startPoint = CGPointMake(activeBounds.size.width * 0.5f, 0.0f);
        CGPoint endPoint = CGPointMake(activeBounds.size.width * 0.5f, activeBounds.size.height);
        
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        free(locations);
        free(components);
        
        /*
         *  Hatched background
         */
        
        if (self.hatchedLinesColor || self.hatchedBackgroundColor) {
            CGContextSaveGState(context); //Save Context State Before Clipping "hatchPath"
            CGRect hatchFrame = CGRectMake(0.0f, buttonOffset-15, activeBounds.size.width, (activeBounds.size.height - buttonOffset+1.0f)+15);
            CGContextClipToRect(context, hatchFrame);
            
            if (self.hatchedBackgroundColor) {
                CGFloat r,g,b,a;
                [self.hatchedBackgroundColor getRed:&r green:&g blue:&b alpha:&a];
                
                CGContextSetRGBFillColor(context, r*255,g*255, b*255, 255);
                CGContextFillRect(context, hatchFrame);
            }
            
            if (self.hatchedLinesColor) {
                CGFloat spacer = 4.0f;
                int rows = (activeBounds.size.width + activeBounds.size.height/spacer);
                CGFloat padding = 0.0f;
                CGMutablePathRef hatchPath = CGPathCreateMutable();
                for(int i=1; i<=rows; i++) {
                    CGPathMoveToPoint(hatchPath, NULL, spacer * i, padding);
                    CGPathAddLineToPoint(hatchPath, NULL, padding, spacer * i);
                }
                CGContextAddPath(context, hatchPath);
                CGPathRelease(hatchPath);
                CGContextSetLineWidth(context, 1.0f);
                CGContextSetLineCap(context, kCGLineCapButt);
                CGContextSetStrokeColorWithColor(context, self.hatchedLinesColor.CGColor);
                CGContextDrawPath(context, kCGPathStroke);
            }
            
            CGContextRestoreGState(context); //Restore Last Context State Before Clipping "hatchPath"
        }
        
        /*
         * Draw vertical line
         */
        
        if (self.verticalLineColor) {
            CGMutablePathRef linePath = CGPathCreateMutable();
            CGFloat linePathY = (buttonOffset - 1.0f) - 15;
            CGPathMoveToPoint(linePath, NULL, 0.0f, linePathY);
            CGPathAddLineToPoint(linePath, NULL, activeBounds.size.width, linePathY);
            CGContextAddPath(context, linePath);
            CGPathRelease(linePath);
            CGContextSetLineWidth(context, 1.0f);
            CGContextSaveGState(context); //Save Context State Before Drawing "linePath" Shadow
            CGContextSetStrokeColorWithColor(context, self.verticalLineColor.CGColor);
            CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.2f].CGColor);
            CGContextDrawPath(context, kCGPathStroke);
            CGContextRestoreGState(context); //Restore Context State After Drawing "linePath" Shadow
        }
        
        /*
         *  Stroke color for inner path
         */
        
        if (self.innerFrameShadowColor || self.innerFrameStrokeColor) {
            CGContextAddPath(context, path);
            CGContextSetLineWidth(context, 3.0f);
            
            if (self.innerFrameStrokeColor) {
               CGContextSetStrokeColorWithColor(context, self.innerFrameStrokeColor.CGColor); 
            }
            if (self.innerFrameShadowColor) {
                CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 6.0f, self.innerFrameShadowColor.CGColor);
            }
            
            CGContextDrawPath(context, kCGPathStroke);
        }
        
        /*
         * Stroke path to cover up pixialation on corners from clipping
         */
        
        CGContextRestoreGState(context); //Restore First Context State Before Clipping "path"
        CGContextAddPath(context, path);
        CGContextSetLineWidth(context, self.outerFrameLineWidth);
        CGContextSetStrokeColorWithColor(context, self.outerFrameColor.CGColor);
        CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 0.0f), 0.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.1f].CGColor);
        CGContextDrawPath(context, kCGPathStroke);
        
        /*
         *  Drawing button labels
         */
        
        for (UIView *subview in self.subviews){
            
            if ([subview isKindOfClass:[UIButton class]])
            {
                UIButton *button = (UIButton *)subview;
                
                CGContextSetTextDrawingMode(context, kCGTextFill);
                CGContextSetFillColorWithColor(context, self.buttonTextColor.CGColor);
                CGContextSetShadowWithColor(context, self.buttonShadowOffset, self.buttonShadowBlur, self.buttonShadowColor.CGColor);
                
                UIFont *buttonFont = button.titleLabel.font;
                
                if (self.buttonFont)
                    buttonFont = self.buttonFont;
                
                
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
                
                /// Make a copy of the default paragraph style
                NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
                /// Set line break mode
                paragraphStyle.lineBreakMode = NSLineBreakByClipping;
                /// Set text alignment
                paragraphStyle.alignment = NSTextAlignmentCenter;
                
                NSDictionary *attributes = @{ NSFontAttributeName: buttonFont,
                                              NSParagraphStyleAttributeName: paragraphStyle };
                
                [button.titleLabel.text drawInRect:CGRectMake(
                                                              button.frame.origin.x,
                                                              button.frame.origin.y+10,
                                                              button.frame.size.width,
                                                              button.frame.size.height)
                                    withAttributes:attributes];
                
#else
                [button.titleLabel.text drawInRect:CGRectMake(button.frame.origin.x, button.frame.origin.y+10, button.frame.size.width, button.frame.size.height) withFont:buttonFont lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
                
#endif
                
            }
            
        }
    }

}

@end

