//
//  BaseDBManager.m
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#import "BaseDBManager.h"

@implementation BaseDBManager
#pragma mark - Shared Instance

+ (instancetype)sharedInstance {
    static BaseDBManager *_sharedOMDBManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedOMDBManager = [[BaseDBManager alloc] init];
    });
    
    return _sharedOMDBManager;
}

#pragma mark - Initialize

- (id) init
{
    self = [super init];
    if (self) {
        BOOL result = [self repareDatabase:nil];
        if (result) {
            NSLog(@"Database initialization successfully!");
        } else {
            NSLog(@"Database initialization failed!");
        }
    }
    return self;
}

- (BOOL)repareDatabase:(NSError *__autoreleasing *)error
{
    // Grab the Documents folder
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Sets the database filename
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DefaultDatabaseFileName];
    
    // Tell FMDB where the database is
    // -- A file system path. The file does not have to exist on disk. If it does not exist, it is created for you.
    // -- from https://github.com/ccgus/fmdb#database-creation
    self.db = [FMDatabase databaseWithPath:filePath];
    [self.db open];
    
    // Get migration path
    NSBundle *parentBundle = [NSBundle bundleForClass:[BaseDBManager class]];
    NSBundle *migrationBundle = [NSBundle bundleWithPath:[parentBundle pathForResource:@"Migrations" ofType:@"bundle"]];
    
    // Create schema_migrations Table, prepare for migrate the database
    FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabase:self.db migrationsBundle:migrationBundle];
    if (! [manager hasMigrationsTable]) {
        if (! [manager createMigrationsTable:error]) {
            return NO;
        }
    }
    
    // Migrate the database if needed
    if ([manager needsMigration]) {
        if (! [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:error]) {
            return NO;
        }
    }
    
    //    [self debugFMDBMigrationManager:manager];
    
    return YES;
}

- (void) dealloc
{
    // Read he about "When to close SQLite database (using FMDB)":
    // - http://stackoverflow.com/questions/15720272/when-to-close-sqlite-database-using-fmdb
    [self.db close];
}

- (void)debugFMDBMigrationManager:(FMDBMigrationManager *)manager
{
    NSLog(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
    NSLog(@"Origin Version: %llu", manager.originVersion);
    NSLog(@"Current version: %llu", manager.currentVersion);
    NSLog(@"All migrations: %@", manager.migrations);
    NSLog(@"Applied versions: %@", manager.appliedVersions);
    NSLog(@"Pending versions: %@", manager.pendingVersions);
}

#pragma mark - Public Functions

+ (NSArray *)columnValuesForUpdate:(MTLModel<MTLFMDBSerializing> *)model
{
    NSArray *columnValues = [MTLFMDBAdapter columnValues:model];
    NSArray *keysValues = [MTLFMDBAdapter primaryKeysValues:model];
    
    NSMutableArray *params = [NSMutableArray array];
    [params addObjectsFromArray:columnValues];
    [params addObjectsFromArray:keysValues];
    
    return params;
}

+ (BOOL)isExists:(MTLModel<MTLFMDBSerializing> *)model
{
    if (!model) return NO;
    
    BOOL isExists = NO;
    NSString * query = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@ WHERE %@", [model.class FMDBTableName],  [MTLFMDBAdapter whereStatementForModel:model]];
    NSArray *params = [MTLFMDBAdapter primaryKeysValues:model];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query withArgumentsInArray:params];
    if  ([resultSet next]) {
        NSNumber *count = [resultSet objectForColumnName:@"count"];
        NSLog(@"Count ---> %@", count);
        isExists = ([count intValue] > 0) ? YES : NO;
    }
    
    return isExists;
}

+ (void)insertOnDuplicateUpdate:(MTLModel<MTLFMDBSerializing> *)entity
{
    if (!entity) return;
    
    if ([self.class isExists:entity])
    {
        NSString *stmt = [MTLFMDBAdapter updateStatementForModel:entity];
        NSArray *params = [self.class columnValuesForUpdate:entity];
        [[BaseDBManager sharedInstance].db executeUpdate:stmt withArgumentsInArray:params];
    }
    else
    {
        NSString *stmt = [MTLFMDBAdapter insertStatementForModel:entity];
        NSArray *params = [MTLFMDBAdapter columnValues:entity];
        
        [[BaseDBManager sharedInstance].db executeUpdate:stmt withArgumentsInArray:params];
    }
}

+ (id)findById:(NSString *)primary_id withClass:(Class)objectClass;
{
    if (!primary_id) return nil;
    
    NSError *error = nil;
    NSString *query = [NSString stringWithFormat:@"select * from %@ where id=%@", [objectClass FMDBTableName], primary_id];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query];
    if ([resultSet next]) {
        return [MTLFMDBAdapter modelOfClass:objectClass fromFMResultSet:resultSet error:&error];
    }
    return nil;
}

+ (id)findUsingPrimaryKeys:(MTLModel<MTLFMDBSerializing> *)model
{
    NSError *error = nil;
    NSString *query = [NSString stringWithFormat:@"select * from %@ where %@", [model.class FMDBTableName], [MTLFMDBAdapter whereStatementForModel:model]];
    NSArray *params = [MTLFMDBAdapter primaryKeysValues:model];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query withArgumentsInArray:params];
    if ([resultSet next]) {
        return [MTLFMDBAdapter modelOfClass:model.class fromFMResultSet:resultSet error:&error];
    }
    return nil;
}

+ (NSArray *)findByColumn:(NSString *)column columnValue:(NSString *)value withClass:(Class)objectClass
{
    if (!column || !value) return nil;
    
    NSError *error = nil;
    NSString *query = [NSString stringWithFormat:@"select * from %@ where %@=%@", [objectClass FMDBTableName], column, value];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        [result addObject:[MTLFMDBAdapter modelOfClass:objectClass fromFMResultSet:resultSet error:&error]];
    }
    return result;
}

+ (NSArray *)findRandomByDictionary:(NSDictionary *)columnDictionary withClass:(Class)objectClass
{
    if (!columnDictionary) return nil;
    
    NSError *error = nil;
    
    NSMutableArray *whereArray = [NSMutableArray array];
    for (NSString *key in columnDictionary) {
        NSString *s = [NSString stringWithFormat:@"%@ = '%@'", key, columnDictionary[key]];
        [whereArray addObject:s];
    }
    
    NSString *whereString = [whereArray componentsJoinedByString:@" AND "];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ORDER BY RANDOM() LIMIT 1", [objectClass FMDBTableName], whereString];
    NSLog(@"select query is %@", query);
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    while ([resultSet next]) {
        [result addObject:[MTLFMDBAdapter modelOfClass:objectClass fromFMResultSet:resultSet error:&error]];
    }
    return result;
}

+ (id)updateDate:(NSDictionary *)columnDictionary withClass:(Class)objectClass
{
    if (!columnDictionary) return nil;
    
    NSMutableArray *whereArray = [NSMutableArray array];
    for (NSString *key in columnDictionary) {
        NSString *s = [NSString stringWithFormat:@"%@ = %@", key, columnDictionary[key]];
        [whereArray addObject:s];
    }
    
    NSString *whereString = [whereArray componentsJoinedByString:@" , "];
    
    NSString *query = [NSString stringWithFormat:@"update %@ set %@", [objectClass FMDBTableName], whereString];
    NSLog(@"update query is %@", query);
    BOOL resultSet = [[BaseDBManager sharedInstance].db executeUpdate:query];
    if (resultSet == NO) {
        NSLog(@"error is %@", [[BaseDBManager sharedInstance].db lastErrorMessage]);
    }
    return nil;
}

+ (NSNumber *)getDataCount:(Class)objectClass
{
    NSNumber *count = 0;
    
    NSString * query = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", [objectClass FMDBTableName]];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query];
    
    if  ([resultSet next]) {
        count = [resultSet objectForColumnName:@"count"];
        NSLog(@"Count ---> %@", count);
    }
    
    return count;
}

+ (NSNumber *)getMaxColumnIdWithClass:(Class)objectClass column:(NSString *)column
{
    NSNumber *maxId = 0;
    
    NSString * query = [NSString stringWithFormat:@"SELECT MAX(%@) as 'maxId' FROM %@", column, [objectClass FMDBTableName]];
    FMResultSet *resultSet = [[BaseDBManager sharedInstance].db executeQuery:query];
    
    if  ([resultSet next]) {
        maxId = [resultSet objectForColumnName:@"maxId"];
    }
    
    return maxId;
}

@end
