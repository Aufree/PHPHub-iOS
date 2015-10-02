//
//  GVUserDefaults+Properties.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "GVUserDefaults.h"

@interface GVUserDefaults (Properties)
@property (nonatomic, copy) NSString *userLoginToken;
@property (nonatomic, copy) NSString *userClientToken;
@property (nonatomic, copy) NSNumber *currentUserId;
@end
