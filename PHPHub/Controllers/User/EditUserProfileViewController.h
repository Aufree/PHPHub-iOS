//
//  EditUserProfileViewController.h
//  PHPHub
//
//  Created by Aufree on 10/4/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditUserProfileViewControllerDelegate <NSObject>
- (void)refreshUserProfileView;
@end

@interface EditUserProfileViewController : UITableViewController
@property (nonatomic, weak) id<EditUserProfileViewControllerDelegate> delegate;
@end
