//
//  CategoryApi.h
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseApi.h"
#import "CategoryEntity.h"

@interface CategoryApi : BaseApi
- (id)getAllTopicCategory:(BaseResultBlock)block;
@end
