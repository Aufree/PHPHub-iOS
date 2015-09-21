//
//  FMDBMigrationManager.h
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

#import <fmdb/FMDatabase.h>
#import <fmdb/FMDatabaseQueue.h>

@protocol FMDBMigrating;

/**
 @abstract The `FMDBMigrationManager` class provides a simple, flexible interface for managing migrations for
 a SQLite database that is accessed via FMDB.
 */
@interface FMDBMigrationManager : NSObject

///-----------------------------------
/// @name Creating a Migration Manager
///-----------------------------------

/**
 @abstract Creates a new migration manager with a given database and migrations bundle.
 @param database The database with which to initialize the migration manager.
 @param bundle The bundle containing the migrations.
 @return A new migration manager.
 */
+ (instancetype)managerWithDatabase:(FMDatabase *)database migrationsBundle:(NSBundle *)bundle;

/**
 @abstract Creates a new migration manager with a database for the given database and migrations bundle.
 @param path The path to a database with which to initialize the migration manager.
 @param bundle The bundle containing the migrations.
 @return A new migration manager.
 */
+ (instancetype)managerWithDatabaseAtPath:(NSString *)path migrationsBundle:(NSBundle *)bundle;

/**
 @abstract Determines whether the receiver will perform a search for dynamically defined migrations. Default: `YES`.
 @discussion When `YES` all classes will be enumerated to search for any that conform to the `FMDBMigrating` protocol.
 */
@property (nonatomic, assign) BOOL dynamicMigrationsEnabled;

///--------------------------------------------------
/// @name Accessing Database Path & Migrations Bundle
///--------------------------------------------------

/**
 @abstract Returns the database of the receiver.
 */
@property (nonatomic, readonly) FMDatabase *database;

/**
 @abstract Returns the migrations bundle for the receiver.
 */
@property (nonatomic, readonly) NSBundle *migrationsBundle;

///-----------------------------
/// @name Accessing Version Info
///-----------------------------

/**
 @abstract Returns the current version of the database managed by the receiver or `0` if the
 migrations table is not present.
 */
@property (nonatomic, readonly) uint64_t currentVersion;

/**
 @abstract Returns the origin version of the database managed by the receiver or `0` if the
 migrations table is not present.
 */
@property (nonatomic, readonly) uint64_t originVersion;

///---------------------------
/// @name Accessing Migrations
///---------------------------

/**
 @abstract Returns all migrations discovered by the receiver. Each object returned conforms to the `FMDBMigrating` protocol. The
 array is returned in ascending order by version.
 @discussion The manager discovers migrations by analyzing all files that end in a .sql extension in the `migrationsBundle`
 and accumulating all classes that conform to the `FMDBMigrating` protocol. These migrations can then be sorted and applied
 to the target database.
 @note The list of migrations is memoized for efficiency.
 */
@property (nonatomic, readonly) NSArray *migrations;

/**
 @abstract Returns the version numbers of the subset of `migrations` that have already been applied to the database
 managed by the receiver in ascending order.
 */
@property (nonatomic, readonly) NSArray *appliedVersions;

/**
 @abstract Returns the version numbers of the subset of `migrations` that have not yet been applied to the database
 managed by the receiver in ascending order.
 */
@property (nonatomic, readonly) NSArray *pendingVersions;

/**
 @abstract Returns a migration object with a given version number or `nil` if none could be found.
 @param version The version of the desired migration.
 @return A migration with the specified version or `nil` if none could be found.
 */
- (id<FMDBMigrating>)migrationForVersion:(uint64_t)version;

/**
 @abstract Returns a migration object with a given name or `nil` if none could be found.
 @param name The name of the desired migration.
 @return A migration with the specified named or `nil` if none could be found.
 */
- (id<FMDBMigrating>)migrationForName:(NSString *)name;

///-------------------------
/// @name Adding a Migration
///-------------------------

/**
 @abstract Adds a migration to the receiver's list.
 @discussion This method can be used to append code based migrations to the set if you do not wish to use dynamic migration discovery. If
 the migration last has been previously computed, adding a migration will recompute the list.
 @param migration The migration to add.
 */
- (void)addMigration:(id<FMDBMigrating>)migration;

/**
 @abstract Adds migrations from the array to the receiver's list.
 @discussion This method can be used to append code based migrations to the set if you do not wish to use dynamic migration discovery. If
 the migration last has been previously computed, adding migrations will recompute the list.
 @param migrations An array of objects conforming to `FMDBMigrating` protocol.
 */
- (void)addMigrations:(NSArray *)migrations;

///------------------------------------
/// @name Managing the Migrations Table
///------------------------------------

/**
 @abstract Returns a Boolean value that indicates if the `schema_migrations` table
 is present in the database.
 */
@property (nonatomic, readonly) BOOL hasMigrationsTable;

/**
 @abstract Creates the `schema_migrations` table used by `FMDBMigrationManager` to maintain an index of applied migrations.
 @param error A pointer to an error object that is set upon failure to create the migrations table.
 @return A Boolean value that indicates if the creation of the migrations table was successful.
 */
- (BOOL)createMigrationsTable:(NSError **)error;

///--------------------------
/// @name Migrating Databases
///--------------------------

/**
 @abstract Returns a Boolean value that indicates if the database managed by the receiver is in need of migration.
 */
@property (nonatomic, readonly) BOOL needsMigration;

/**
 @abstract Migrates the database managed by the receiver to the specified version, optionally providing progress via a block.
 @discussion Migration is performed within a transaction that is rolled back if any errors occur during migration.
 @param version The target version to migrate the database to. Pass `UINT64_MAX` to migrate to the latest version.
 @param progressBlock An optional block to be invoked each time a migration is applied. The block has no return value and accepts a single `NSProgress` argument. The
 progress object can be used to cancel a migration in progress.
 @param error A pointer to an error object that is set upon failure to complete the migrations.
 @return `YES` if migration was successful, else `NO`.
 */
- (BOOL)migrateDatabaseToVersion:(uint64_t)version progress:(void (^)(NSProgress *progress))progressBlock error:(NSError **)error;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 @abstract The `FMDBMigrating` protocol is adopted by classes that wish to provide migration of SQLite databases accessed via FMDB. The
 `FMDBMigrationManager` project ships with a single concrete implementation in the `FMDBFileMigration` class. Non file backed 
 migrations can be implemented by conforming to the `FMDBMigrating` protocol.
 */
@protocol FMDBMigrating <NSObject>

///-------------------------------------
/// @name Accessing Migration Properties
///-------------------------------------

/**
 @abstract The name of the migration.
 */
@property (nonatomic, readonly) NSString *name;

/**
 @abstract The numeric version of the migration. 
 @discussion While monotonically incremented versions are fully supported, it is recommended that to use a timestamp format such as
 201406063106474. Timestamps avoid unnecessary churn in a codebase that is heavily branched.
 */
@property (nonatomic, readonly) uint64_t version;

///--------------------------
/// @name Migrating Databases
///--------------------------

/**
 @abstract Tells the receiver to apply its changes to the given database and return a Boolean value indicating success or failure.
 @discussion The `FMDBMigrationManager` manages a transaction while migrations are being applied. Should any call to `migrateDatabase:error` return `NO`,
 then the transaction is rolled back.
 @param database The database on which to apply the migration.
 @param error A pointer to an error object to set should the transaction fail.
 @return A Boolean value indicating if the
 */
- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error;

@end

/**
 @abstract The `FMDBFileMigration` class provides a concrete implementation of the `FMDBMigrating` protocol that models
 a migration stored on disk a SQL file. The filename encodes the name and version of the migration. Conformant filenames are
 of the form `[version]_[name].sql`. 
 */
@interface FMDBFileMigration : NSObject <FMDBMigrating>

///--------------------------------
/// @name Creating a File Migration
///--------------------------------

/**
 @abstract Creates and returns a new migration with the file at the given path.
 @discussion Conformance of filenames can be evaluated with the `FMDBIsMigrationAtPath` utility function.
 @param path The path to a file containing a SQL migration with a conformant filename.
 */
+ (instancetype)migrationWithPath:(NSString *)path;

/**
 @abstract The path to the SQL migration file on disk.
 */
@property (nonatomic, readonly) NSString *path;

/**
 @abstract A convenience accessor for retrieving the SQL from the receiver's path.
 */
@property (nonatomic, readonly) NSString *SQL;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////////////

/**
 @abstract The domain for errors created by `FMDBMigrationManager`.
 */
extern NSString *const FMDBMigrationManagerErrorDomain;

/**
 @abstract A key for an `NSNumber` object in the `userInfo` of an `NSProgress` object specifying the version 
 that the database was just migrated to.
 @see `migrateDatabase:error:`
 */
extern NSString *const FMDBMigrationManagerProgressVersionUserInfoKey;

/**
 @abstract A key for an `id<FMDBMigrating>` object in the `userInfo` of an `NSProgress` object that identifies
 the migration that was just applied to the database.
 @see `migrateDatabase:error:`
 */
extern NSString *const FMDBMigrationManagerProgressMigrationUserInfoKey;

/**
 @abstract Enumerates the errors returned by FMDBMigrationManager
 */
typedef NS_ENUM(NSUInteger, FMDBMigrationManagerError) {
    /// Indicates that migration was halted due to cancellation
    FMDBMigrationManagerErrorMigrationCancelled  = 1
};

/**
 @abstract Returns a Boolean value that indicates if the file at the given path is an FMDB Migration.
 @discussion This function evaluates the last path component of the input string against the regular expression `/\d{1,15}_.+sql$/`.
 @param path The path to inspect.
 @return `YES` if the path could be identified as a migration, else `NO`.
 */
BOOL FMDBIsMigrationAtPath(NSString *path);
