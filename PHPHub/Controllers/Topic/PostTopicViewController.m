//
//  PostTopicViewController.m
//  PHPHub
//
//  Created by Aufree on 10/9/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "PostTopicViewController.h"
#import "UITextView+Placeholder.h"

#import "CategoryModel.h"
#import "TopicModel.h"

@interface PostTopicViewController ()
@property (weak, nonatomic) IBOutlet UITextField *topicTitleTF;
@property (weak, nonatomic) IBOutlet UITextView *topicContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *selectCategoryButton;
@property (weak, nonatomic) IBOutlet UIPickerView *categoryPickView;
@property (strong, nonatomic) NSMutableArray *categoryNameArray;
@property (strong, nonatomic) NSMutableArray *categoryEntites;
@property (assign, nonatomic) BOOL didSelectedCategory;
@end

@implementation PostTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布话题";
    self.categoryNameArray = [[NSMutableArray alloc] init];
    self.categoryEntites = [[NSMutableArray alloc] init];
    
    [self setup];
    [self createRightButtonItem];
    [self getAllCategoryFromServer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.categoryPickView.hidden = NO;
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

- (void)getAllCategoryFromServer {
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            NSArray *tempCategoryEntites = data[@"entities"];
            for (CategoryEntity *category in tempCategoryEntites) {
                [weakself.categoryEntites addObject:category];
                [weakself.categoryNameArray addObject:category.categoryName];
            }
            [weakself.categoryPickView reloadAllComponents];
        }
    };
    
    [[CategoryModel Instance] getAllTopicCategory:callback];
}

- (void)postTopicToServer {
    TopicEntity *topic = [TopicEntity new];
    topic.topicTitle = _topicTitleTF.text;
    topic.topicBody = _topicContentTextView.text;
    NSInteger seletedCategoryRow = [_categoryPickView selectedRowInComponent:0];
    CategoryEntity *selectedCategory = [_categoryEntites objectAtIndex:seletedCategoryRow];
    topic.categoryId = selectedCategory.categoryId;
    
    [SVProgressHUD show];
    __weak typeof(self) weakself = self;
    BaseResultBlock callback =^ (NSDictionary *data, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            TopicEntity *topicEntity = data[@"entity"];
            topicEntity.user = [[CurrentUser Instance] userInfo];
            topicEntity.topicRepliesCount = @0;
            topicEntity.voteCount = @0;
            [weakself.navigationController popViewControllerAnimated:NO];
            [JumpToOtherVCHandler jumpToTopicDetailWithTopic:topicEntity];
            [AnalyticsHandler logEvent:@"发布帖子" withCategory:kTopicAction label:[NSString stringWithFormat:@"%@ topicId:%@", [CurrentUser Instance].userLabel, topic.topicId]];
        } else {
            [SVProgressHUD showErrorWithStatus:@"发布失败, 请重试"];
        }
        
        self.navigationItem.rightBarButtonItem.enabled = YES;
    };
    
    if ([self topicIsValid]) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [[TopicModel Instance] createTopic:topic withBlock:callback];
    } else {
        if (![self topicContentIsValid]) {
            [SVProgressHUD showErrorWithStatus:@"帖子内容长度应大于 1"];
        } else {
            [SVProgressHUD showErrorWithStatus:@"信息未填写完整"];
        }
    }
}

- (IBAction)didTouchSelectCategoryButton:(id)sender {
    [self.view endEditing:YES];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (_categoryEntites.count > 0) {
        CategoryEntity *category = [_categoryEntites objectAtIndex:row];
        NSString *buttonTitle = [NSString stringWithFormat:@"发布到 [%@] 下", category.categoryName];
        [_selectCategoryButton setTitle:buttonTitle forState:UIControlStateNormal];
        _didSelectedCategory = YES;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_categoryNameArray count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_categoryNameArray objectAtIndex:row];
}

- (BOOL)topicIsValid {
    return _topicTitleTF.text.length > 0 && _topicContentTextView.text.length > 1 && _didSelectedCategory;
}

- (BOOL)topicContentIsValid {
    return _topicContentTextView.text.length > 1;
}
@end
