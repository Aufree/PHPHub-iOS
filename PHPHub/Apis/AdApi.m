//
//  AdApi.m
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "AdApi.h"
#import "LaunchScreenAdEntity.h"

@implementation AdApi

- (id)getAdvertsLaunchScreen:(BaseResultBlock)block {
    NSString *urlPath = @"adverts/launch_screen";
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [LaunchScreenAdEntity arrayOfEntitiesFromArray:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    return [[BaseApi clientGrantInstance] GET:urlPath
                                   parameters:nil
                                      success:successBlock
                                      failure:failureBlock];
}

@end
