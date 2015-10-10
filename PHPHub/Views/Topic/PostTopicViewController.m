//
//  PostTopicViewController.m
//  PHPHub
//
//  Created by Aufree on 10/9/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "PostTopicViewController.h"
#import "UITextView+Placeholder.h"

#import "NodeModel.h"
#import "TopicModel.h"

@interface PostTopicViewController ()
@property (weak, nonatomic) IBOutlet UITextField *topicTitleTF;
@property (weak, nonatomic) IBOutlet UITextView *topicContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectNodeButton;
@property (weak, nonatomic) IBOutlet UIPickerView *nodePickView;
@property (strong, nonatomic) NSMutableArray *nodeNameArray;
@property (copy, nonatomic) NSArray *nodeEntites;
@end

@implementation PostTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布话题";
    self.nodeNameArray = [[NSMutableArray alloc] init];
    
    [self setup];
    [self createRightButtonItem];
    [self getAllNodeFromServer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.nodePickView.hidden = NO;
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

- (void)getAllNodeFromServer {
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            weakself.nodeEntites = data[@"entities"];
            for (NodeEntity *node in weakself.nodeEntites) {
                [weakself.nodeNameArray addObject:node.nodeName];
            }
            [weakself.nodePickView reloadAllComponents];
        }
    };
    
    [[NodeModel Instance] getAllTopicNode:callback];
}

- (void)postTopicToServer {
    TopicEntity *topic = [TopicEntity new];
    topic.topicTitle = _topicTitleTF.text;
    topic.topicBody = _topicContentTextView.text;
    NSInteger seletedNodeRow = [_nodePickView selectedRowInComponent:0];
    NodeEntity *selectedNode = [_nodeEntites objectAtIndex:seletedNodeRow];
    topic.nodeId = selectedNode.nodeId;
    
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            TopicEntity *topicEntity = data[@"entity"];
            topicEntity.user = [[CurrentUser Instance] userInfo];
            topicEntity.topicRepliesCount = @0;
            topicEntity.voteCount = @0;
            [JumpToOtherVCHandler jumpToTopicDetailWithTopic:topicEntity];
        }
    };
    
    [[TopicModel Instance] createTopic:topic withBlock:callback];
}

- (IBAction)didTouchSelectNodeButton:(id)sender {
    [self.view endEditing:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NodeEntity *node = [_nodeEntites objectAtIndex:row];
    NSString *buttonTitle = [NSString stringWithFormat:@"发布到 [%@] 下", node.nodeName];
    [_selectNodeButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_nodeNameArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_nodeNameArray objectAtIndex:row];
}
@end
