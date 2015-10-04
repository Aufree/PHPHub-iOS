//
//  EditUserProfileViewController.m
//  PHPHub
//
//  Created by Aufree on 10/4/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "EditUserProfileViewController.h"
#import "UITextView+Placeholder.h"

@interface EditUserProfileViewController ()
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *customTextField;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;
@property (weak, nonatomic) IBOutlet UITextField *realnameTF;
@end

@implementation EditUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑个人资料";
    
    _realnameTF.text = [[CurrentUser Instance] userInfo].realName;
    [self customUserProfileTextField];
    [self customUserProfileTextView];
}

- (void)customUserProfileTextField {
    for (UITextField *textField in _customTextField) {
        textField.layer.cornerRadius = 5;
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    }
}

- (void)customUserProfileTextView {
    _introTextView.layer.cornerRadius = 5;
    _introTextView.placeholder = @"简介";
    _introTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
}

@end
