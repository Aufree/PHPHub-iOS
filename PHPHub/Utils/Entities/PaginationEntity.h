//
//  PaginationEntity.h
//  PHPHub
//
//  Created by Aufree on 9/22/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

@interface PaginationEntity : BaseEntity
@property (nonatomic, assign) NSUInteger totalPages;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger perPage;
@end
