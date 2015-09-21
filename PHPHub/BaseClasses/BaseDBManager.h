//
//  BaseDBManager.h
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "MTLModel.h"
#import "FMDBMigrationManager.h"
#import "MTLFMDBAdapter.h"

#define DefaultDatabaseFileName @"MainDataBase.sqlite"

@interface BaseDBManager : NSObject
@property(strong, nonatomic)FMDatabase *db;

+ (instancetype)sharedInstance;

+ (NSArray *)columnValuesForUpdate:(MTLModel<MTLFMDBSerializing> *)model;
+ (BOOL)isExists:(MTLModel<MTLFMDBSerializing> *)model;
+ (NSNumber *)getDataCount:(Class)objectClass;

+ (void)insertOnDuplicateUpdate:(MTLModel<MTLFMDBSerializing> *)model;
+ (id)findById:(NSString *)primary_id withClass:(Class)objectClass;

+ (id)findUsingPrimaryKeys:(MTLModel<MTLFMDBSerializing> *)model;
+ (NSArray *)findByColumn:(NSString *)column columnValue:(NSString *)value withClass:(Class)objectClass;
+ (NSArray *)findRandomByDictionary:(NSDictionary *)columnDictionary withClass:(Class)objectClass;
+ (id)updateDate:(NSDictionary *)columnDictionary withClass:(Class)objectClass;
+ (NSNumber *)getMaxColumnIdWithClass:(Class)objectClass column:(NSString *)column;
@end
