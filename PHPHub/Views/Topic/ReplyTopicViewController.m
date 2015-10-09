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
    
    BaseResultBlock callback =^(NSDictionary *data, NSError *error) {
        if (!error) {
            
        }
    };
    
    [[TopicModel Instance] addCommentToTopic:comment withBlock:callback];
}

@end
