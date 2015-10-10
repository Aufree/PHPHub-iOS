//
//  NodeApi.m
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "NodeApi.h"

@implementation NodeApi

- (id)getAllTopicNode:(BaseResultBlock)block {
    NSString *urlPath = @"nodes";
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        if (data[@"data"]) {
            data[@"entities"] = [NodeEntity arrayOfEntitiesFromArray:data[@"data"]];
        }
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
