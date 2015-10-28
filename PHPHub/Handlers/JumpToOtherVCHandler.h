//
//  JumpToOtherVCHandler.h
//  PHPHub
//
//  Created by Aufree on 10/8/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicEntity.h"

@interface JumpToOtherVCHandler : NSObject
+ (UIViewController *)getTabbarViewController;
+ (void)pushToOtherView:(UIViewController *)vc animated:(BOOL)animated;
+ (void)presentToOtherView:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion;
+ (void)jumpToTopicDetailWithTopic:(TopicEntity *)topic;
+ (void)jumpToLoginVC:(void (^)(void))completion;
+ (void)jumpToTopicDetailWithTopicId:(NSNumber *)topicId;
+ (void)jumpToUserProfileWithUserId:(NSNumber *)userId;
+ (void)jumpToCommentListVCWithTopic:(TopicEntity *)topic;
+ (void)jumpToWebVCWithUrlString:(NSString *)url;
@end
