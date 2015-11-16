//
//  BaseWebView.h
//  PHPHub
//
//  Created by Aufree on 10/27/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseWebView : UIWebView
@property (nonatomic, copy) NSString *urlString;
- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;
@end
