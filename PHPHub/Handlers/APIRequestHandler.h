//
//  APIRequestHandler.h
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequestHandler : NSObject
@property(nonatomic, copy) NSString *grantType;
- (void)registerNotifications;
@end
