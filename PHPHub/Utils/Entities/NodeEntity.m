//
//  NodeEntity.m
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "NodeEntity.h"

@implementation NodeEntity
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"nodeId" : @"id",
             @"nodeName" : @"name",
             @"parentNode" : @"parent_node",
             };
}
@end
