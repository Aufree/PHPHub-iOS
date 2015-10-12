//
//  TopicSearchBar.m
//  PHPHub
//
//  Created by Aufree on 10/12/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "TopicSearchBar.h"

@implementation TopicSearchBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.placeholder = @"搜索";
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backgroundImage = [[UIImage alloc] init];
    }
    return self;
}

@end
