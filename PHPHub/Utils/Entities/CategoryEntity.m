//
//  CategoryEntity.m
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "CategoryEntity.h"

@implementation CategoryEntity
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"categoryId" : @"id",
             @"categoryName" : @"name",
             };
}
@end
