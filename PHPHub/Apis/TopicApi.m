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
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=node,last_reply_user,user&per_page=20&page=%ld", (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getExcellentTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=node,last_reply_user,user&filter=excellent&per_page=20&page=%ld", (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getNewestTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=node,last_reply_user,user&filter=recent&per_page=20&page=%ld", (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getHotsTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=node,last_reply_user,user&filter=vote&per_page=20&page=%ld", (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getNoReplyTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=node,last_reply_user,user&filter=nobody&per_page=20&page=%ld", (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getJobTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=node,last_reply_user,user&filter=jobs&per_page=20&page=%ld", (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getWiKiList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"topics?include=node,last_reply_user,user&filter=wiki&per_page=20&page=%ld", (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getTopicListByUrlPath:(NSString *)urlPath block:(BaseResultBlock)block{
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData)
    {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [TopicEntity arrayOfEntitiesFromArray:data[@"data"]];
        data[@"pagination"] = [PaginationEntity entityFromDictionary:data[@"meta"][@"pagination"]];
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
