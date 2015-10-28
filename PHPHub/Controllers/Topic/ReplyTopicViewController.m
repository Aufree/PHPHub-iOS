//
//  ReplyTopicViewController.m
//  PHPHub
//
//  Created by Aufree on 10/9/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "ReplyTopicViewController.h"
#import "UITextView+Placeholder.h"
#import "TopicModel.h"

@interface ReplyTopicViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@end

@implementation ReplyTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发表回复";
    
    [self createRightButtonItem];
    _commentTextView.layer.cornerRadius = 5.0f;
    _commentTextView.placeholder = @"请使用 Markdown 格式书写 ;-)";
    [_commentTextView becomeFirstResponder];
}

# pragma mark Post Comment

- (void)createRightButtonItem {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"send_icon"]
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(postTopicCommentToServer)];
    rightBarButtonItem.tintColor = [UIColor colorWithRed:0.502 green:0.776 blue:0.200 alpha:1.000];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

- (void)postTopicCommentToServer {
    
    CommentEntity *comment = [[CommentEntity alloc] init];
    comment.topicId = _topicId;
    comment.commentBody = _commentTextView.text;
    [AnalyticsHandler logEvent:@"回复帖子" withCategory:kTopicAction label:[NSString stringWithFormat:@"%@ topicId:%@", [CurrentUser Instance].userLabel, _topicId]];
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    [SVProgressHUD show];
    
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^(NSDictionary *data, NSError *error) {
        if (!error) {
            [SVProgressHUD dismiss];
            [weakself.navigationController popViewControllerAnimated:YES];
            if (weakself.delegate) {
                if ([weakself.delegate respondsToSelector:@selector(reloadCommentListView)]) {
                    [weakself.delegate reloadCommentListView];
                } else if ([weakself.delegate respondsToSelector:@selector(jumpToCommentsView)]) {
                    [weakself.delegate jumpToCommentsView];
                }
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"回复失败, 请重试"];
        }
        self.navigationItem.rightBarButtonItem.enabled = YES;
    };
    
    if (_commentTextView.text.length > 1) {
        [[TopicModel Instance] addCommentToTopic:comment withBlock:callback];
    } else {
        [SVProgressHUD showErrorWithStatus:@"评论字数至少为两个"];
    }
}

@end
