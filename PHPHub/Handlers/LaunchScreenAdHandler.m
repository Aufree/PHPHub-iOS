//
//  LaunchScreenAdHandler.m
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "LaunchScreenAdHandler.h"
#import "LaunchScreenAdView.h"

#import "LaunchScreenAdEntity.h"
#import "AdModel.h"
#import "LaunchScreenAdDBManager.h"

#import "UIImageView+WebCache.h"
#import "NSDate+DateTools.h"

@implementation LaunchScreenAdHandler
+ (void)checkShouldShowLaunchScreenAd {
    if (![GVUserDefaults standardUserDefaults].lastTimeShowLaunchScreenAd) {
        [GVUserDefaults standardUserDefaults].lastTimeShowLaunchScreenAd = [NSDate date];
    }
    
    BOOL hasPastOneHour = [[NSDate date] hoursFrom:[GVUserDefaults standardUserDefaults].lastTimeShowLaunchScreenAd] >= 1;
    
    if (hasPastOneHour) {
        [self loadLaunchScreenAdEntity];
    }
    
    [[AdModel Instance] getAdvertsLaunchScreen:nil];
}

+ (void)showLaunchScreenAd {
    if (![GVUserDefaults standardUserDefaults].lastTimeShowLaunchScreenAd) {
        [GVUserDefaults standardUserDefaults].lastTimeShowLaunchScreenAd = [NSDate date];
    }
    
    [self loadLaunchScreenAdEntity];
    
    [[AdModel Instance] getAdvertsLaunchScreen:nil];
}

+ (void)loadLaunchScreenAdEntity {
    [GVUserDefaults standardUserDefaults].lastTimeShowLaunchScreenAd = [NSDate date];
    LaunchScreenAdEntity *adEntity = [LaunchScreenAdDBManager findLaunchScreenAdByExpries];
    if (adEntity) {
        [self createLaunchScreenAdWithAdEntity:adEntity];
    }
}

+ (void)createLaunchScreenAdWithAdEntity:(LaunchScreenAdEntity *)launchScreenAdEntity {
    
    NSString *screenImageUrl = IS_IPHONE_4_OR_LESS ? launchScreenAdEntity.smallImage : launchScreenAdEntity.bigImage;
    NSString *imageWidth = [NSString stringWithFormat:@"%.f", SCREEN_WIDTH * 2];
    NSString *imageHeight = [NSString stringWithFormat:@"%.f", SCREEN_HEIGHT * 2];
    NSURL *imageLink = [BaseHelper qiniuImageCenter:screenImageUrl withWidth:imageWidth withHeight:imageHeight];
    
    BOOL imageIsCache = [SDWebImageManager.sharedManager cachedImageExistsForURL:imageLink];
    
    if (!imageIsCache) {
        [[[UIImageView alloc] init] sd_setImageWithURL:imageLink];
        return;
    }
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    LaunchScreenAdView *animatedImagesView = [[LaunchScreenAdView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    animatedImagesView.transitionDuration = [launchScreenAdEntity.displayTime doubleValue];
    animatedImagesView.durationTimeLabel.text = [NSString stringWithFormat:@"%@s", launchScreenAdEntity.displayTime];
    [animatedImagesView startAnimateWithImageLink:imageLink];
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [keyWindow addSubview:animatedImagesView];
    
    keyWindow.windowLevel = UIWindowLevelStatusBar + 1;
}

+ (void)removeLaunchScreenAd:(BOOL)shouldJumpToOtherVC {
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    
    for (LaunchScreenAdView *animatedImagesView in keyWindow.subviews) {
        if ([animatedImagesView isKindOfClass:[LaunchScreenAdView class]]) {
            [UIView animateWithDuration:0.5
                             animations:^{
                                 animatedImagesView.alpha = 0.0;
                                 keyWindow.windowLevel = UIWindowLevelNormal;
                             }
                             completion:^(BOOL finished){
                                 [animatedImagesView removeFromSuperview];
                                 
                                 if (shouldJumpToOtherVC) {
                                     LaunchScreenAdEntity *adEntity = [LaunchScreenAdDBManager findLaunchScreenAdByExpries];
                                     if (adEntity) {
                                         [self jumpToOtherViewController:adEntity];
                                     }
                                 }
                             }];
        }
    }
}

+ (void)jumpToOtherViewController:(LaunchScreenAdEntity *)entity {
    if (entity.type == LaunchScreenTypeUnknow || !entity.type) {
        return;
    }
    
    NSNumber *payloadNumber = [self covertToNumber:entity.payload];
    if (entity.type == LaunchScreenTypeByTopic) {
        [JumpToOtherVCHandler jumpToTopicDetailWithTopicId:payloadNumber];
    } else if (entity.type == LaunchScreenTypeByUser) {
        [JumpToOtherVCHandler jumpToUserProfileWithUserId:payloadNumber];
    } else if (entity.type == LaunchScreenTypeByWeb) {
        [JumpToOtherVCHandler jumpToWebVCWithUrlString:entity.payload];
    }
}

+ (NSNumber *)covertToNumber:(NSString *)numberString {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    return [formatter numberFromString:numberString];
}
@end
