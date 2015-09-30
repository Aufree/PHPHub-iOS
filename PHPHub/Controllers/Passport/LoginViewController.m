//
//  LoginViewController.m
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "LoginViewController.h"
#import "AccessTokenHandler.h"

@interface LoginViewController () <QRCodeReaderDelegate>
@property (weak, nonatomic) IBOutlet UIButton *scanLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *introLoginButton;
@end

@implementation LoginViewController

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
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *reader = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            reader                        = [QRCodeReaderViewController new];
            reader.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        reader.delegate = self;
        
        [reader setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:reader animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Reader not supported by the current device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSArray *loginInfo = [result componentsSeparatedByString:@","];
        NSString *username = loginInfo[0];
        NSString *loginToken = loginInfo[1];
        
        NSURL *url = [NSURL URLWithString:APIBaseURL];
        AFOAuth2Manager *oauthClient = [AFOAuth2Manager clientWithBaseURL:url clientID:Client_id secret:Client_secret];
        
        [oauthClient authenticateUsingOAuthWithURLString:APIAccessTokenURL
                                                username:username
                                              loginToken:loginToken
                                                   scope:@""
                                                 success:^(AFOAuthCredential *credential) {
                                                     [AccessTokenHandler storeLoginTokenGrantAccessToken:credential.accessToken];
                                                     [[BaseApi loginTokenGrantInstance] setUpLoginTokenGrantRequest];
                                                     [self.navigationController popToRootViewControllerAnimated:YES];
                                                 } failure:^(NSError *error) {
                                                     
                                                 }];
    }];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)didTouchIntroLoginButton:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
