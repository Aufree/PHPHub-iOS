//
//  PostTopicViewController.m
//  PHPHub
//
//  Created by Aufree on 10/9/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "PostTopicViewController.h"
#import "UITextView+Placeholder.h"

@interface PostTopicViewController ()
@property (weak, nonatomic) IBOutlet UITextField *topicTitleTF;
@property (weak, nonatomic) IBOutlet UITextView *topicContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectNodeButton;
@end

@implementation PostTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布话题";
    
    [self setup];
    [self createRightButtonItem];
}

- (void)setup {
    _topicTitleTF.layer.cornerRadius = 5.0f;
    _topicTitleTF.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
    _topicContentTextView.layer.cornerRadius = 5.0f;
    _topicContentTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
    _topicContentTextView.placeholder = @"请使用 Markdown 格式书写 ;-)";
}

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"send_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(postTopicToServer)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)postTopicToServer {
    
}

- (IBAction)didTouchSelectNodeButton:(id)sender {
}
@end
