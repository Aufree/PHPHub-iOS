//
//  LoginViewController.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QRCodeReaderDelegate.h"
#import "QRCodeReaderViewController.h"

@protocol LoginViewControllerDelegate <NSObject>
- (void)updateMeView;
@end

@interface LoginViewController : UIViewController
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@property (nonatomic, copy) void (^completeLoginBlock)(void);
@end
