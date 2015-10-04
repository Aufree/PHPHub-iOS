//
//  EditUserProfileViewController.m
//  PHPHub
//
//  Created by Aufree on 10/4/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "EditUserProfileViewController.h"
#import "UITextView+Placeholder.h"
#import "TPKeyboardAvoidingTableView.h"

@interface EditUserProfileViewController ()
@property (strong, nonatomic) UserEntity *user;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *customTextField;
@property (weak, nonatomic) IBOutlet UITextView *introTextView;
@property (weak, nonatomic) IBOutlet UITextField *realnameTF;
@property (weak, nonatomic) IBOutlet UITextField *cityTF;
@property (weak, nonatomic) IBOutlet UITextField *twitterTF;
@property (weak, nonatomic) IBOutlet UITextField *githubTF;
@property (weak, nonatomic) IBOutlet UITextField *blogTF;
@end

@implementation EditUserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"编辑个人资料";
    self.user = [[CurrentUser Instance] userInfo];
    
    [self customUserProfileTextField];
    [self customUserProfileTextView];
    
    [self loadCurrentUserData];
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

- (void)loadCurrentUserData {
    _realnameTF.text = _user.realName;
    _cityTF.text = _user.city;
    _twitterTF.text = _user.twitterAccount;
    _githubTF.text = _user.githubName;
    _blogTF.text = _user.blogURL;
    _introTextView.text = _user.introduction;
}

@end
