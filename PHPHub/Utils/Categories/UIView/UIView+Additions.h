//
//  UIView+Additions.h
//
//  Created by Jin on 15/3/25.
//  Copyright (c) 2015年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Additions)

- (id) initWithParent:(UIView *)parent;
+ (id) viewWithParent:(UIView *)parent;
- (void)removeAllSubViews;
- (UIViewController*)viewController;


// Position of the top-left corner in superview's coordinates
@property CGPoint position;
@property CGFloat x;
@property CGFloat y;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;


// makes hiding more logical
@property BOOL	visible;


// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

@end

@interface UIImageView (MFAdditions)

- (void) setImageWithName:(NSString *)name;

@end
