//
//  CategoryApi.m
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "CategoryApi.h"

@implementation CategoryApi

- (id)getAllTopicCategory:(BaseResultBlock)block {
    NSString *urlPath = @"categories";
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        if (data[@"data"]) {
            data[@"entities"] = [CategoryEntity arrayOfEntitiesFromArray:data[@"data"]];
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
