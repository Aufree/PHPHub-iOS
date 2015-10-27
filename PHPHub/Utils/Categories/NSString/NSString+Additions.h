//
//  NSString+Additions.h
//  PHPHub
//
//  Created by Aufree on 10/1/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)
+ (BOOL)isStringEmpty:(NSString *)string;
+ (NSNumber *)covertToNumber:(NSString *)numberString;
@end
