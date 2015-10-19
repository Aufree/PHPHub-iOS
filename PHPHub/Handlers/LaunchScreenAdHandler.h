//
//  LaunchScreenAdHandler.h
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LaunchScreenAdEntity.h"

@interface LaunchScreenAdHandler : NSObject
@property (nonatomic, strong) LaunchScreenAdEntity *launchScreenAdEntity;
+ (void)checkShouldShowLaunchScreenAd;
+ (void)showLaunchScreenAd;
+ (void)createLaunchScreenAdWithAdEntity:(LaunchScreenAdEntity *)launchScreenAdEntity;
+ (void)removeLaunchScreenAd:(BOOL)shouldJumpToOtherVC;
@end
