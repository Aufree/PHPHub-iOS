//
//  FMDBMigrationManager.m
//  FMDBMigrationManager
//
//  Created by Blake Watters on 6/4/14.
//  Copyright (c) 2014 Layer Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "FMDBMigrationManager.h"
#import <objc/runtime.h>

// Public Constants
NSString *const FMDBMigrationManagerErrorDomain = @"com.layer.FMDBMigrationManager.errors";
NSString *const FMDBMigrationManagerProgressVersionUserInfoKey = @"version";
NSString *const FMDBMigrationManagerProgressMigrationUserInfoKey = @"migration";

// Private Constants
static NSString *const FMDBMigrationFilenameRegexString = @"^(\\d+)_?((?<=_)[\\w\\s-]+)?(?<!_)\\.sql$";

BOOL FMDBIsMigrationAtPath(NSString *path)
{
    static NSRegularExpression *migrationRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        migrationRegex = [NSRegularExpression regularExpressionWithPattern:FMDBMigrationFilenameRegexString options:0 error:nil];
    });
    NSString *filename = [path lastPathComponent];
    return [migrationRegex rangeOfFirstMatchInString:filename options:0 range:NSMakeRange(0, [filename length])].location != NSNotFound;
}

static NSArray *FMDBClassesConformingToProtocol(Protocol *protocol)
{
    NSMutableArray *conformingClasses = [NSMutableArray new];
    Class *classes = NULL;
    int numClasses = objc_getClassList(NULL, 0);
    if (numClasses > 0 ) {
        classes = (Class *)malloc(sizeof(Class) * numClasses);
        numClasses = objc_getClassList(classes, numClasses);
        for (int index = 0; index < numClasses; index++) {
            Class nextClass = classes[index];
            if (class_conformsToProtocol(nextClass, protocol)) {
                [conformingClasses addObject:nextClass];
            }
        }
        free(classes);
    }
    return conformingClasses;
}

@interface FMDBMigrationManager ()
@property (nonatomic) FMDatabase *database;
@property (nonatomic, assign) BOOL shouldCloseOnDealloc;
@property (nonatomic) NSArray *migrations;
@property (nonatomic) NSMutableArray *externalMigrations;
@end

@implementation FMDBMigrationManager

+ (instancetype)managerWithDatabaseAtPath:(NSString *)path migrationsBundle:(NSBundle *)bundle
{
    FMDatabase *database = [FMDatabase databaseWithPath:path];
    return [[self alloc] initWithDatabase:database migrationsBundle:bundle];
}

+ (instancetype)managerWithDatabase:(FMDatabase *)database migrationsBundle:(NSBundle *)bundle
{
    return [[self alloc] initWithDatabase:database migrationsBundle:bundle];
}

// Designated initializer
- (id)initWithDatabase:(FMDatabase *)database migrationsBundle:(NSBundle *)migrationsBundle
{
    if (!database) [NSException raise:NSInvalidArgumentException format:@"Cannot initialize a `%@` with nil `database`.", [self class]];
    if (!migrationsBundle) [NSException raise:NSInvalidArgumentException format:@"Cannot initialize a `%@` with nil `migrationsBundle`.", [self class]];
    self = [super init];
    if (self) {
        _database = database;
        _migrationsBundle = migrationsBundle;
        _dynamicMigrationsEnabled = YES;
        _externalMigrations = [NSMutableArray new];
        if (![database goodConnection]) {
            self.shouldCloseOnDealloc = YES;
            [database open];
        }
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
}

- (void)dealloc
{
    if (self.shouldCloseOnDealloc) [_database close];
}

- (BOOL)hasMigrationsTable
{
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name=?", @"schema_migrations"];
    if ([resultSet next]) {
        [resultSet close];
        return YES;
    }
    return NO;
}

- (BOOL)needsMigration
{
    return !self.hasMigrationsTable || [self.pendingVersions count] > 0;
}

- (BOOL)createMigrationsTable:(NSError **)error
{
    BOOL success = [self.database executeStatements:@"CREATE TABLE schema_migrations(version INTEGER UNIQUE NOT NULL)"];
    if (!success && error) *error = self.database.lastError;
    return success;
}

- (uint64_t)currentVersion
{
    if (!self.hasMigrationsTable) return 0;
    
    uint64_t version = 0;
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT MAX(version) FROM schema_migrations"];
    if ([resultSet next]) {
        version = [resultSet unsignedLongLongIntForColumnIndex:0];
    }
    [resultSet close];
    return version;;
}

- (uint64_t)originVersion
{
    if (!self.hasMigrationsTable) return 0;
    
    uint64_t version = 0;
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT MIN(version) FROM schema_migrations"];
    if ([resultSet next]) {
        version = [resultSet unsignedLongLongIntForColumnIndex:0];
    }
    [resultSet close];
    return version;
}

- (NSArray *)appliedVersions
{
    if (!self.hasMigrationsTable) return nil;
    
    NSMutableArray *versions = [NSMutableArray new];
    FMResultSet *resultSet = [self.database executeQuery:@"SELECT version FROM schema_migrations"];
    while ([resultSet next]) {
        uint64_t version = [resultSet unsignedLongLongIntForColumnIndex:0];
        [versions addObject:@(version)];
    }
    [resultSet close];
    return [versions sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *)pendingVersions
{
    if (!self.hasMigrationsTable) return [[self.migrations valueForKey:@"version"] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableArray *pendingVersions = [[[self migrations] valueForKey:@"version"] mutableCopy];
    [pendingVersions removeObjectsInArray:self.appliedVersions];
    return [pendingVersions sortedArrayUsingSelector:@selector(compare:)];
}

- (void)addMigration:(id<FMDBMigrating>)migration
{
    NSParameterAssert(migration);
    [self addMigrationsAndSortByVersion:@[ migration ]];
}

- (void)addMigrations:(NSArray *)migrations
{
    NSParameterAssert(migrations);
    if (![migrations isKindOfClass:[NSArray class]]) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Failed to add migrations because `migrations` argument is not an array." userInfo:nil];
    }
    for (id<NSObject> migration in migrations) {
        if (![migration conformsToProtocol:@protocol(FMDBMigrating)]) {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Failed to add migrations because an object in `migrations` array doesn't conform to the `FMDBMigrating` protocol." userInfo:nil];
        }
    }
    [self addMigrationsAndSortByVersion:migrations];
}

- (NSArray *)migrations
{
    // Memoize the migrations list
    if (_migrations) return _migrations;
    
    NSArray *migrationPaths = [self.migrationsBundle pathsForResourcesOfType:@"sql" inDirectory:nil];
    NSRegularExpression *migrationRegex = [NSRegularExpression regularExpressionWithPattern:FMDBMigrationFilenameRegexString options:0 error:nil];
    NSMutableArray *migrations = [NSMutableArray new];
    for (NSString *path in migrationPaths) {
        NSString *filename = [path lastPathComponent];
        if ([migrationRegex rangeOfFirstMatchInString:filename options:0 range:NSMakeRange(0, [filename length])].location != NSNotFound) {
            FMDBFileMigration *migration = [FMDBFileMigration migrationWithPath:path];
            [migrations addObject:migration];
        }
    }
    
    // Find all classes implementing FMDBMigrating
    if (self.dynamicMigrationsEnabled) {
        NSArray *conformingClasses = FMDBClassesConformingToProtocol(@protocol(FMDBMigrating));
        for (Class migrationClass in conformingClasses) {
            if ([migrationClass isSubclassOfClass:[FMDBFileMigration class]]) continue;
            id<FMDBMigrating> migration = [migrationClass new];
            [migrations addObject:migration];
        }
    }
    
    // Append any externally added migrations
    [migrations addObjectsFromArray:self.externalMigrations];
    
    // Sort into our final set
    _migrations = [migrations sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"version" ascending:YES] ]];
    return _migrations;
}

- (id<FMDBMigrating>)migrationForVersion:(uint64_t)version
{
    for (id<FMDBMigrating>migration in [self migrations]) {
        if (migration.version == version) return migration;
    }
    return nil;
}

- (id<FMDBMigrating>)migrationForName:(NSString *)name
{
    for (id<FMDBMigrating>migration in [self migrations]) {
        if ([migration.name isEqualToString:name]) return migration;
    }
    return nil;
}

- (BOOL)migrateDatabaseToVersion:(uint64_t)version progress:(void (^)(NSProgress *progress))progressBlock error:(NSError **)error
{
    BOOL success = YES;
    NSArray *pendingVersions = self.pendingVersions;
    NSProgress *progress = [NSProgress progressWithTotalUnitCount:[pendingVersions count]];
    for (NSNumber *migrationVersionNumber in pendingVersions) {
        [self.database beginTransaction];
        
        uint64_t migrationVersion = [migrationVersionNumber unsignedLongLongValue];
        if (migrationVersion > version) {
            [self.database commit];
            break;
        }
        id<FMDBMigrating> migration = [self migrationForVersion:migrationVersion];
        success = [migration migrateDatabase:self.database error:error];
        if (!success) {
            [self.database rollback];
            break;
        }
        success = [self.database executeUpdate:@"INSERT INTO schema_migrations(version) VALUES (?)", @(migration.version)];
        if (!success) {
            [self.database rollback];
            break;
        }
        
        // Emit progress tracking and check for cancellation
        progress.completedUnitCount++;
        if (progressBlock) {
            [progress setUserInfoObject:@(migrationVersion) forKey:FMDBMigrationManagerProgressVersionUserInfoKey];
            [progress setUserInfoObject:migration forKey:FMDBMigrationManagerProgressMigrationUserInfoKey];
            progressBlock(progress);
            if (progress.cancelled) {
                success = NO;
                
                NSDictionary *userInfo = @{ NSLocalizedDescriptionKey: @"Migration was halted due to cancellation." };
                if (error) *error = [NSError errorWithDomain:FMDBMigrationManagerErrorDomain code:FMDBMigrationManagerErrorMigrationCancelled userInfo:userInfo];
                [self.database rollback];
                break;
            }
        }
        
        [self.database commit];
    }
    return success;
}

- (void)addMigrationsAndSortByVersion:(NSArray *)migrations
{
    [self.externalMigrations addObjectsFromArray:migrations];
    
    // Append to the existing list if already computed
    if (_migrations) {
        NSMutableArray *currentMigrations = [_migrations mutableCopy];
        [currentMigrations addObjectsFromArray:migrations];
        _migrations = [currentMigrations sortedArrayUsingDescriptors:@[ [NSSortDescriptor sortDescriptorWithKey:@"version" ascending:YES] ]];
    }
}

@end

static BOOL FMDBMigrationScanMetadataFromPath(NSString *path, uint64_t *version, NSString **name)
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:FMDBMigrationFilenameRegexString options:0 error:&error];
    if (!regex) {
        NSLog(@"[FMDBMigration] Failed constructing regex: %@", error);
        return NO;
    }
    NSString *migrationName = [path lastPathComponent];
    NSTextCheckingResult *result = [regex firstMatchInString:migrationName options:0 range:NSMakeRange(0, [migrationName length])];
    if ([result numberOfRanges] != 3) {
        return NO;
    }
    NSString *versionString = [migrationName substringWithRange:[result rangeAtIndex:1]];
    if (!versionString) {
        return NO;
    }
    *version = strtoull([versionString UTF8String], NULL, 10);
    NSRange range = [result rangeAtIndex:2];
    *name = (range.length) ? [migrationName substringWithRange:[result rangeAtIndex:2]] : nil;
    return YES;
}

@interface FMDBFileMigration ()
@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) uint64_t version;
@end

@implementation FMDBFileMigration

+ (instancetype)migrationWithPath:(NSString *)path
{
    return [[self alloc] initWithPath:path];
}

- (id)initWithPath:(NSString *)path
{
    NSString *name;
    uint64_t version;
    if (!FMDBMigrationScanMetadataFromPath(path, &version, &name)) return nil;
    
    self = [super init];
    if (self) {
        _path = path;
        _version = version;
        _name = name;
    }
    return self;
}

- (id)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Failed to call designated initializer." userInfo:nil];
}

- (NSString *)SQL
{
    return [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
}

- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error
{
    BOOL success = [database executeStatements:self.SQL];
    if (!success && error) *error = database.lastError;
    return success;
}

@end
