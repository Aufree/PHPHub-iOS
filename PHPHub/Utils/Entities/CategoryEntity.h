//
//  CategoryEntity.h
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

@interface CategoryEntity : BaseEntity
@property (nonatomic, strong) NSNumber *categoryId;
@property (nonatomic, copy) NSString *categoryName;
@end
