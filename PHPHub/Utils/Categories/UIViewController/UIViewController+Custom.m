//
//  UIViewController+Custom.m
//  PHPHub
//
//  Created by Aufree on 10/3/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "UIViewController+Custom.h"

@implementation UIViewController (Custom)

+ (void)load {
    
    Method viewWillAppear = class_getInstanceMethod(self, @selector(customViewWillAppear:));
    
    Method customViewWillAppear = class_getInstanceMethod(self, @selector(viewWillAppear:));
    method_exchangeImplementations(viewWillAppear, customViewWillAppear);
}

- (void)customViewWillAppear:(BOOL)animated {
    [self customViewWillAppear:animated];
    
    if ([self.navigationController.viewControllers indexOfObject:self] != 0  && !self.navigationItem.hidesBackButton) {
        [self createBackButton];
    }
}

- (void)createBackButton {
    UIImage *backImage = [UIImage imageNamed:@"back"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:backImage
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(popViewControllerWithAnimation)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    self.navigationItem.backBarButtonItem = nil;
}

- (void)popViewControllerWithAnimation {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
