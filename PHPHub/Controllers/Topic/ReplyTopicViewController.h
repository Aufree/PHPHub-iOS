//
//  ReplyTopicViewController.h
//  PHPHub
//
//  Created by Aufree on 10/9/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReplyTopicViewControllerDelegate <NSObject>
- (void)jumpToCommentsView;
@end

@interface ReplyTopicViewController : UIViewController
@property (nonatomic, copy) NSNumber *topicId;
@property (nonatomic, weak) id<ReplyTopicViewControllerDelegate> delegate;
@end
