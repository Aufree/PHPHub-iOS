//
//  BaseWebView.h
//  PHPHub
//
//  Created by Aufree on 10/27/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BaseWebViewDelegate <NSObject>
@optional
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
@end

@interface BaseWebView : UIWebView
@property (nonatomic, copy) NSString *urlString;
@property (nonatomic, weak) id<BaseWebViewDelegate> baseWebDelegate;
- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;
@end
