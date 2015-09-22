//
//  PaginationEntity.m
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "PaginationEntity.h"

@implementation PaginationEntity

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"totalPages" : @"total_pages",
             @"currentPage" : @"current_page",
             @"perPage" : @"per_page"
             };
}

@end
