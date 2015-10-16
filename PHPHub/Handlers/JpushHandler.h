//
//  JpushHandler.h
//  PHPHub
//
//  Created by Aufree on 10/16/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APService.h"

@interface JpushHandler : NSObject
+ (void)setupJpush:(NSDictionary *)launchOptions;
+ (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias;
+ (NSString *)logSet:(NSSet *)dic;
+ (void)sendUserIdToAlias;
+ (void)sendEmptyAlias;
@end
