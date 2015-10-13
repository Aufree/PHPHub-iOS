//
//  NotificationApi.m
//  PHPHub
//
//  Created by Aufree on 10/13/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "NotificationApi.h"

@implementation NotificationApi
- (id)getNotificationList:(BaseResultBlock)block atPage:(NSInteger)pageIndex {
    NSString *urlPath = [NSString stringWithFormat:@"me/notifications?include=from_user,topic&per_page=20&page=%ld", pageIndex];
    
    BaseRequestSuccessBlock successBlock = ^(NSURLSessionDataTask * __unused task, id rawData) {
        NSMutableDictionary *data = [(NSDictionary *)rawData mutableCopy];
        data[@"entities"] = [NotificationEntity arrayOfEntitiesFromArray:data[@"data"]];
        data[@"pagination"] = [PaginationEntity entityFromDictionary:data[@"meta"][@"pagination"]];
        if (block) block(data, nil);
    };
    
    BaseRequestFailureBlock failureBlock = ^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) block(nil, error);
    };
    
    return [[BaseApi loginTokenGrantInstance] GET:urlPath
                                   parameters:nil
                                      success:successBlock
                                      failure:failureBlock];
}
@end
