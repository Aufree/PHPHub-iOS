//
//  AdModel.h
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseModel.h"
#import "AdApi.h"

@interface AdModel : BaseModel
@property (nonatomic, strong) AdApi *api;
- (id)getAdvertsLaunchScreen:(BaseResultBlock)block;
@end
