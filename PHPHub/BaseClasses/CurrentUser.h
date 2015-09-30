//
//  CurrentUser.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUser : NSObject
+ (CurrentUser *)Instance;
- (void)setupClientRequestState;
@end
