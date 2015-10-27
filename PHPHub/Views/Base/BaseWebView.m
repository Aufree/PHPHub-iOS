//
//  BaseWebView.m
//  PHPHub
//
//  Created by Aufree on 10/27/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "BaseWebView.h"
#import "TOWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "JTSImageViewController.h"

#import "AccessTokenHandler.h"

@interface BaseWebView () <UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIActivityIndicatorView *activityView;;
@property WebViewJavascriptBridge* bridge;
@end

@implementation BaseWebView

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString {
    self = [super initWithFrame:frame];
    if (self) {
        self.urlString = urlString;
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    [self setup];
}

- (void)setup {
    self.delegate = self;
    self.scrollView.delegate = self;
    [self addSubview:self.activityView];
    [self loadTopicContentWebView];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *imageUrl = data[@"imageUrl"];
        [self openImageInApp:imageUrl];
    }];
}

- (UIActivityIndicatorView *)activityView {
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.center = CGPointMake(self.width/2, self.height/2);
        [_activityView startAnimating];
    }
    return _activityView;
}

- (void)loadTopicContentWebView {
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setValue:[AccessTokenHandler getClientGrantAccessTokenFromLocal] forHTTPHeaderField:@"Authorization"];
    [self loadRequest:requestObj];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    if (navigationType == UIWebViewNavigationTypeLinkClicked && ![url.scheme isEqualToString:@"phphub"]) {
        if ([url.host isEqualToString:PHPHubHost]) {
            NSArray *pathComponents = url.pathComponents;
            if (pathComponents.count > 1 && pathComponents[1] && pathComponents[2]) {
                NSString *urlType = pathComponents[1];
                NSNumber *payload = pathComponents[2];
                if ([urlType isEqualToString:@"users"]) {
                    [JumpToOtherVCHandler jumpToUserProfileWithUserId:payload];
                } else if ([urlType isEqualToString:@"topics"]) {
                    [JumpToOtherVCHandler jumpToTopicDetailWithTopicId:payload];
                }
                return NO;
            }
        }
        [JumpToOtherVCHandler jumpToWebVCWithUrlString:url.absoluteString];
        return NO;
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_activityView removeFromSuperview];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_activityView removeFromSuperview];
}

- (void)openImageInApp:(NSString *)imageUrlString {
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    imageInfo.imageURL = [NSURL URLWithString:imageUrlString];
    imageInfo.referenceRect = self.frame;
    imageInfo.referenceView = self.superview;
    
    // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_None];
    
    // Present the view controller.
    [imageViewer showFromViewController:[JumpToOtherVCHandler getTabbarViewController] transition:JTSImageViewControllerTransition_FromOffscreen];
}

#pragma mark Scroll View Delegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_baseWebDelegate && [_baseWebDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [_baseWebDelegate scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_baseWebDelegate && [_baseWebDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [_baseWebDelegate scrollViewWillBeginDragging:scrollView];
    }
}

@end
