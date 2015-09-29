//
//  PassportViewController.m
//  PHPHub
//
//  Created by Aufree on 9/29/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "PassportViewController.h"

@interface PassportViewController ()
@property (weak, nonatomic) IBOutlet UIButton *scanLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *introLoginButton;
@end

@implementation PassportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请登录";
    self.navigationItem.hidesBackButton = YES;

    [self drawButtonBorder:_scanLoginButton borderColor:[UIColor colorWithRed:0.886 green:0.643 blue:0.251 alpha:1.000]];
    [self drawButtonBorder:_introLoginButton borderColor:[UIColor colorWithRed:0.275 green:0.698 blue:0.875 alpha:1.000]];
}

- (void)drawButtonBorder:(UIButton *)button borderColor:(UIColor *)color {
    button.layer.cornerRadius = 10.0f;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = color.CGColor;
}

- (IBAction)didTouchScanLoginButton:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)didTouchIntroLoginButton:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
