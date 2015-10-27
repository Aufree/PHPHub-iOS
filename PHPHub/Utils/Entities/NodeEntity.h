//
//  NodeEntity.h
//  PHPHub
//
//  Created by Aufree on 9/23/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseEntity.h"

@interface NodeEntity : BaseEntity
@property (nonatomic, strong) NSNumber *nodeId;
@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, strong) NSNumber *parentNode;
@end
