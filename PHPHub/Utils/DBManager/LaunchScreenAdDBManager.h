//
//  LaunchScreenAdDBManager.h
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseDBManager.h"

@interface LaunchScreenAdDBManager : BaseDBManager
+ (id)findLaunchScreenAdByExpries;
+ (id)getLaunchScreenAdByExpriesInLocal;
+ (id)eraseLaunchScreenAdData;
@end
