//
//  AdModel.m
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "AdModel.h"
#import "LaunchScreenAdDBManager.h"
#import "LaunchScreenAdEntity.h"

@implementation AdModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _api = [[AdApi alloc] init];
    }
    return self;
}

- (id)getAdvertsLaunchScreen:(BaseResultBlock)block {
    BaseResultBlock callback = ^(NSDictionary *data, NSError *error) {
        if (!error) {
            NSArray *adEntities = [data objectForKey:@"entities"];
            [self insertAdEntitiesToLocalDataBase:adEntities];
        }
        if (block) block(data, error);
    };
    
    if ([[CurrentUser Instance] hasClientToken]) {
        return [_api getAdvertsLaunchScreen:callback];
    } else {
        return nil;
    }
}

- (void)insertAdEntitiesToLocalDataBase:(NSArray *)adEntities {
    [LaunchScreenAdDBManager eraseLaunchScreenAdData];
    
    if (adEntities.count > 0) {
        [[BaseDBManager sharedInstance].db beginTransaction];
        for (int i = 0; i < adEntities.count; i++) {
            LaunchScreenAdEntity *entity = [adEntities objectAtIndex:i];
            [LaunchScreenAdDBManager insertOnDuplicateUpdate:entity];
        }
        [[BaseDBManager sharedInstance].db commit];
        
        [self checkLaunchScreenAdImageHasCached:adEntities];
    }
}

- (void)checkLaunchScreenAdImageHasCached:(NSArray *)adEntities {
    for (int i = 0; i < adEntities.count; i++) {
        LaunchScreenAdEntity *launchScreenAdEntity = [adEntities objectAtIndex:i];
        NSString *screenImageUrl = IS_IPHONE_4_OR_LESS ? launchScreenAdEntity.smallImage : launchScreenAdEntity.bigImage;
        NSString *imageWidth = [NSString stringWithFormat:@"%.f", SCREEN_WIDTH * 2];
        NSString *imageHeight = [NSString stringWithFormat:@"%.f", SCREEN_HEIGHT * 2];
        NSURL *imageLink = [BaseHelper qiniuImageCenter:screenImageUrl withWidth:imageWidth withHeight:imageHeight];
        BOOL imageIsCache = [SDWebImageManager.sharedManager cachedImageExistsForURL:imageLink];
        if (!imageIsCache) {
            [[[UIImageView alloc] init] sd_setImageWithURL:imageLink];
        }
    }
}

@end
