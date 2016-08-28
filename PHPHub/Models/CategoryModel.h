//
//  CategoryModel.h
//  PHPHub
//
//  Created by Aufree on 10/10/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseModel.h"
#import "CategoryApi.h"

@interface CategoryModel : BaseModel
@property (nonatomic, strong) CategoryApi *api;
- (id)getAllTopicCategory:(BaseResultBlock)block;
@end
