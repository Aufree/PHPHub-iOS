//
//  LaunchScreenAdDBManager.m
//  PHPHub
//
//  Created by Aufree on 10/19/15.
//  Copyright © 2015 ESTGroup. All rights reserved.
//

#import "LaunchScreenAdDBManager.h"
#import "LaunchScreenAdEntity.h"

@implementation LaunchScreenAdDBManager

+ (id)findLaunchScreenAdByExpries {
    LaunchScreenAdEntity *entity = [self getLaunchScreenAdByExpriesInLocal];
    
    if (entity) {
        return entity;
    }
    
    return nil;
}

+ (id)getLaunchScreenAdByExpriesInLocal {
    NSError *error = nil;
    MTLModel<MTLFMDBSerializing> *model = [[LaunchScreenAdEntity alloc] init];
    NSString *query = [NSString stringWithFormat:@"select * from %@ where expires_at > datetime(CURRENT_TIMESTAMP,'localtime') order by datetime(expires_at) asc limit 1", [model.class FMDBTableName]];
    NSArray *params = [MTLFMDBAdapter primaryKeysValues:model];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query withArgumentsInArray:params];
    if ([resultSet next]) {
        return [MTLFMDBAdapter modelOfClass:model.class fromFMResultSet:resultSet error:&error];
    }
    return nil;
}

+ (id)eraseLaunchScreenAdData {
    NSError *error = nil;
    MTLModel<MTLFMDBSerializing> *model = [[LaunchScreenAdEntity alloc] init];
    NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", [model.class FMDBTableName]];
    NSArray *params = [MTLFMDBAdapter primaryKeysValues:model];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query withArgumentsInArray:params];
    if ([resultSet next]) {
        return [MTLFMDBAdapter modelOfClass:model.class fromFMResultSet:resultSet error:&error];
    }
    return nil;
}

@end
