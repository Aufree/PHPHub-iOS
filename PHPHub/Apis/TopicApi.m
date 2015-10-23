//
//  TopicApi.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "TopicApi.h"

@implementation TopicApi

- (NSString *)getUrlPathWithFilter:(NSString *)filter atPage:(NSInteger)pageIndex{
    NSString *urlPath = @"topics?include=node,last_reply_user,user&filters=%@&per_page=20&page=%ld&columns=user(signature)";
    return [NSString stringWithFormat:urlPath, filter, (long)pageIndex];
}

- (id)getAll:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [self getUrlPathWithFilter:@"" atPage:pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getExcellentTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [self getUrlPathWithFilter:@"excellent" atPage:pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getNewestTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [self getUrlPathWithFilter:@"newest" atPage:pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getHotsTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [self getUrlPathWithFilter:@"vote" atPage:pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getNoReplyTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [self getUrlPathWithFilter:@"nobody" atPage:pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getJobTopicList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [self getUrlPathWithFilter:@"jobs" atPage:pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getWiKiList:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [self getUrlPathWithFilter:@"wiki" atPage:pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"user/%ld/topics?include=node,last_reply_user,user&per_page=20&page=%ld&columns=user(signature)"
                         , (long)userId, (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getFavoriteTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"user/%ld/favorite/topics?include=node,last_reply_user,user&per_page=20&page=%ld&columns=user(signature)"
                         , (long)userId, (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getAttentionTopicListByUser:(NSInteger)userId callback:(BaseResultBlock)block atPage:(NSInteger)pageIndex
{
    NSString *urlPath = [NSString stringWithFormat:@"user/%ld/attention/topics?include=node,last_reply_user,user&per_page=20&page=%ld&columns=user(signature)"
                         , (long)userId, (long)pageIndex];
    
    return [self getTopicListByUrlPath:urlPath block:block];
}

- (id)getTopicById:(NSInteger)topicId callback:(BaseResultBlock)block
{
    NSString *urlPath = [NSString stringWithFormat:@"topics/%ld?include=user,node&columns=user(signature)", (long)topicId];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData)
    {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entity"] = [TopicEntity entityFromDictionary:data[@"data"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error)
    {
        if (block) block(nil, error);
    };
    
    return [self getDataFromServer:urlPath successBlock:successBlock failureBlock:failureBlock];
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

- (id)addCommentToTopic:(CommentEntity *)comment withBlock:(BaseResultBlock)block {
    NSString *urlPath = @"replies";
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        if (data[@"data"]) {
            data[@"entity"] = [CommentEntity entityFromDictionary:data[@"data"]];
        }
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    return [[BaseApi loginTokenGrantInstance] POST:urlPath
                                       parameters:[comment transformToDictionary]
                                          success:successBlock
                                          failure:failureBlock];
}

- (id)favoriteTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block {
    NSString *urlString = [NSString stringWithFormat:@"topics/%@/favorite", topicId];
    return [self topicAction:topicId withBlock:block urlString:urlString deleteAction:NO];
}

- (id)cancelFavoriteTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block {
    NSString *urlString = [NSString stringWithFormat:@"topics/%@/favorite", topicId];
    return [self topicAction:topicId withBlock:block urlString:urlString deleteAction:YES];
}

- (id)attentionTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block {
    NSString *urlString = [NSString stringWithFormat:@"topics/%@/attention", topicId];
    return [self topicAction:topicId withBlock:block urlString:urlString deleteAction:NO];
}

- (id)cancelAttentionTopicById:(NSNumber *)topicId withBlock:(BaseResultBlock)block {
    NSString *urlString = [NSString stringWithFormat:@"topics/%@/attention", topicId];
    return [self topicAction:topicId withBlock:block urlString:urlString deleteAction:YES];
}

- (id)voteUpTopic:(NSNumber *)topicId withBlock:(BaseResultBlock)block {
    NSString *urlString = [NSString stringWithFormat:@"topics/%@/vote-up", topicId];
    return [self topicAction:topicId withBlock:block urlString:urlString deleteAction:NO];
}

- (id)voteDownTopic:(NSNumber *)topicId withBlock:(BaseResultBlock)block {
    NSString *urlString = [NSString stringWithFormat:@"topics/%@/vote-down", topicId];
    return [self topicAction:topicId withBlock:block urlString:urlString deleteAction:NO];
}

- (id)topicAction:(NSNumber *)topicId withBlock:(BaseResultBlock)block urlString:(NSString *)urlString deleteAction:(BOOL)deleteAction {
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    if (deleteAction) {
        return [[BaseApi loginTokenGrantInstance] DELETE:urlString
                                              parameters:nil
                                                 success:successBlock
                                                 failure:failureBlock];
    } else {
        return [[BaseApi loginTokenGrantInstance] POST:urlString
                                              parameters:nil
                                                 success:successBlock
                                                 failure:failureBlock];
    }
}

- (id)createTopic:(TopicEntity *)entity withBlock:(BaseResultBlock)block {
    NSString *urlPath = @"topics";
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        if (data[@"data"]) {
            data[@"entity"] = [TopicEntity entityFromDictionary:data[@"data"]];
        }
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    return [[BaseApi loginTokenGrantInstance] POST:urlPath
                                        parameters:[entity transformToDictionary]
                                           success:successBlock
                                           failure:failureBlock];
}

- (id)getDataFromServer:(NSString *)urlPath successBlock:(BaseRequestSuccessBlock)successBlock failureBlock:(BaseRequestFailureBlock)failureBlock {
    if ([[CurrentUser Instance] isLogin]) {
        return [[BaseApi loginTokenGrantInstance] GET:urlPath
                                           parameters:nil
                                              success:successBlock
                                              failure:failureBlock];
    } else {
        return [[BaseApi clientGrantInstance] GET:urlPath
                                       parameters:nil
                                          success:successBlock
                                          failure:failureBlock];
    }
}
@end
