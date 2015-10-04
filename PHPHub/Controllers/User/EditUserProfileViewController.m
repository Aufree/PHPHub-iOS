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
#import "SVProgressHUD.h"

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
    [self createRightButtonItem];
    
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

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tick_icon"]
                                                                                              style:UIBarButtonItemStylePlain
                                                                                             target:self
                                                                                             action:@selector(updateUserProfile)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)loadCurrentUserData {
    _realnameTF.text = _user.realName;
    _cityTF.text = _user.city;
    _twitterTF.text = _user.twitterAccount;
    _githubTF.text = _user.githubName;
    _blogTF.text = _user.blogURL;
    _introTextView.text = _user.introduction;
}

- (void)updateUserProfile {
    _user.realName = _realnameTF.text;
    _user.city = _cityTF.text;
    _user.twitterAccount = _twitterTF.text;
    _user.githubName = _githubTF.text;
    _user.blogURL = _blogTF.text;
    _user.introduction = _introTextView.text;
    
    [SVProgressHUD show];
    
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"更新失败, 请稍后再试"];
        }
    };
    
    [[UserModel Instance] updateUserProfile:_user withBlock:callback];
}

@end
