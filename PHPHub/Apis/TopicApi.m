//
//  TopicApi.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicApi.h"

@implementation TopicApi
- (id)getAll:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=last_reply_user,user"];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData)
    {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [TopicEntity arrayOfEntitiesFromArray:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        if (block) block(nil, error);
    };
    
    return [[BaseApi clientGrantInstance] GET:urlPath
                                   parameters:nil
                                      success:successBlock
                                      failure:failureBlock];
}

- (id)getNewestTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=user,node&filter=recent&per_page=15&page=1"];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData)
    {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [TopicEntity arrayOfEntitiesFromArray:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        if (block) block(nil, error);
    };
    
    return [[BaseApi clientGrantInstance] GET:urlPath
                                   parameters:nil
                                      success:successBlock
                                      failure:failureBlock];
}

- (id)getHotsTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=user,node&filter=vote&per_page=15&page=1"];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData)
    {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [TopicEntity arrayOfEntitiesFromArray:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        if (block) block(nil, error);
    };
    
    return [[BaseApi clientGrantInstance] GET:urlPath
                                   parameters:nil
                                      success:successBlock
                                      failure:failureBlock];
}

- (id)getNoReplyTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=user,node&filter=nobody&per_page=15&page=1"];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData)
    {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [TopicEntity arrayOfEntitiesFromArray:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        if (block) block(nil, error);
    };
    
    return [[BaseApi clientGrantInstance] GET:urlPath
                                   parameters:nil
                                      success:successBlock
                                      failure:failureBlock];
}

- (id)getWiKiList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=user,node&filter=wiki&per_page=15&page=1"];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData)
    {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [TopicEntity arrayOfEntitiesFromArray:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        if (block) block(nil, error);
    };
    
    return [[BaseApi clientGrantInstance] GET:urlPath
                                   parameters:nil
                                      success:successBlock
                                      failure:failureBlock];
}
@end
