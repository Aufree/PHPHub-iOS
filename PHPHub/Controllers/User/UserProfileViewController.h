//
//  UserProfileViewController.h
//  PHPHub
//
//  Created by Aufree on 10/2/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserEntity.h"

@interface UserProfileViewController : UITableViewController
@property (nonatomic, strong) UserEntity *userEntity;
@end
