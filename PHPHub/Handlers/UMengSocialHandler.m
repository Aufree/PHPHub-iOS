//
//  UMengSocialHandler.m
//  PHPHub
//
//  Created by Aufree on 10/15/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "UMengSocialHandler.h"

@interface UMengSocialHandler () <UMSocialUIDelegate>
@end

@implementation UMengSocialHandler

+ (void)setup {
    [UMSocialData setAppKey:UMENG_APPKEY];
    [UMSocialQQHandler setQQWithAppId:UMENG_QQ_ID appKey:UMENG_QQ_APPKEY url:PHPHubUrl];
    [UMSocialWechatHandler setWXAppId:WX_APP_ID appSecret:WX_APP_SECRET url:PHPHubUrl];
    [UMSocialSinaHandler openSSOWithRedirectURL:SinaRedirectURL];
}

+ (void)shareWithShareURL:(NSString *)shareURL
            shareImageUrl:(NSString *)shareImageUrl
               shareTitle:(NSString *)shareTitle
                shareText:(NSString *)shareText
                presentVC:(UIViewController *)vc
                 delegate:(id <UMSocialUIDelegate>)delegate {
    
    [UMSocialData defaultData].extConfig.title = shareTitle;
    // Global share link
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:shareImageUrl];
    // WeChat Timeline Custom
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = shareURL;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = shareURL;
    [UMSocialData defaultData].extConfig.qqData.url = shareURL;
    
    [UMSocialSnsService presentSnsIconSheetView:vc
                                         appKey:UMENG_APPKEY
                                      shareText:shareText
                                     shareImage:[UIImage imageNamed:@"logo"]
                                shareToSnsNames:[NSArray arrayWithObjects:
                                                 UMShareToWechatSession,
                                                 UMShareToWechatTimeline,
                                                 UMShareToQQ,
                                                 UMShareToSina,
                                                 nil]
                                       delegate:delegate];
}
@end