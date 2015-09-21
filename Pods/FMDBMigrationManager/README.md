# FMDBMigrationManager

[![Build Status](https://travis-ci.org/layerhq/FMDBMigrationManager.png?branch=master)](https://travis-ci.org/layerhq/FMDBMigrationManager)
[![Pod Version](http://img.shields.io/cocoapods/v/FMDBMigrationManager.svg?style=flat)](http://cocoadocs.org/docsets/FMDBMigrationManager/)
[![Pod Platform](http://img.shields.io/cocoapods/p/FMDBMigrationManager.svg?style=flat)](http://cocoadocs.org/docsets/FMDBMigrationManager/)
[![Pod License](http://img.shields.io/cocoapods/l/FMDBMigrationManager.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0.html)

**A SQLite schema migration management system for [FMDB](https://github.com/ccgus/fmdb).**

FMDBMigrationManager is the missing schema management system for SQLite databases accessed via the [FMDB](https://github.com/ccgus/fmdb)
library. It provides a simple, flexible solution for introducing versioned schema management into a new or existing Cocoa application using
SQLite and FMDB for persistence.

## Features

* Supports the creation and management of a dedicated migrations table within the host database.
* Applies migrations safely using SQLite transactions.
* Basic migrations are implemented as flat SQL files with a naming convention that encodes the version and name.
* Supports code migration implementations for performing object graph migrations not expressible as SQL.
* Discovers code based migrations via Objective-C runtime introspection of protocol conformance.
* Includes a lightweight, yet rich API for introspecting schema state.
* Exposes the status of migrations in progress and supports cancellation of migration via `NSProgress`.

## Implementation Details

FMDBMigrationManager works by introducing a simple `schema_migrations` table into the database under management. This table has a schema of:

```sql
CREATE TABLE schema_migrations(
	version INTEGER UNIQUE NOT NULL
);
```

Each row in the `schema_migrations` corresponds to a single migration that has been applied and represents a unique version of the schema. This schema
supports any versioning scheme that is based on integers, but it is recommended that you utilize an integer that encodes a timestamp. 

### Timestamped Versions

Timestamps are preferable to a monotonically incrementing integers because they better support branched workflows as you do not need to resequence migrations when multiple
lines of development are brought together. Timestamps with sufficient levels of precision are ensured a very low potential for conflict and are trivially
sortable.

The recommended format for timestamped migrations uses sub-second precision and can be generated via the `date` utility on platforms that provide GNU coreutils
via `date +"%Y%m%d%H%M%S%3N"`. Unfortunately the build of `date` that ships with Mac OS X does not natively support this format. It can instead be generated via
an invocation of Ruby: `ruby -e "puts Time.now.strftime('%Y%m%d%H%M%S%3N').to_i"`.

### Migration Naming

FMDBMigrationManager favors migrations that are expressed as flat SQL files. These files can then be included into the host project via any `NSBundle`. In order
for FMDBMigrationManager to be able to identify migration files within the bundle and interet the version they represent, the filename must encode the versioning
data and may optionally include a descriptive name for the migration. Migrations filenames are matched with a regular expression that will recognize filenames of
the form: `(<Numeric Version Number>)_?(<Descriptive Name)?.sql`. The name is optional but if included must be delimited by an underscore, but the version and the 
.sql file extension are mandatory.

Example of valid migration names include:

* 1.sql
* 201406063106474_create_mb-demo-schema
* 9999_ChangeTablesToNewFormat.sql
* 2014324_This is the Description.sql

### Computing Origin and Current Version

Before FMDBMigrationManager can determine what migrations should be applied to a given database, it must be able to asses details about the current version of the schema.

To compute the "origin version" (the version of the schema at the time the database was created), select the minimum value for the `version` column in the `schema_migrations` table:

```sql
SELECT MIN(version) FROM schema_migrations
```

The current version of the database is computable by selecting the maximum value for the `version` column present in the `schema_migrations` table:

```sql
SELECT MAX(version) FROM schema_migrations
```

Note that knowing the current version is not sufficient for computing if the database is fully migrated. This is because migrations that were created in the past may not yet 
have been merged, released and applied yet.

### Computing Unapplied Migrations

Determining what migrations should be applied to a given database is done using the following algorithm:

1. Compute the origin version of the database.
1. Build an array containing the `version` for all migrations within a given bundle.
1. Build an array of all migration versions that have already been applied to the database (`SELECT version FROM schema_migrations`)
1. Remove any migrations from the list with a version less than the origin version of the database.
1. Diff the arrays of migrations. The set that remains is the set of pending migrations.
1. Order the set of unapplied migrations into an array of ascending values and apply them in order from oldest to newest.

## Usage

FMDBMigrationManager is designed to be very straightforward to use. The extensive unit test coverage that accompanies the library provides a great body of 
reference code. The sections below quickly sketch out how the most common tasks are accomplished with the library.

Note that instances of `FMDBMigrationManager` are initialized with a `migrationsBundle`. This bundle is scanned for migration files using the approach
detailed in the implementation section. For a typical iOS app, it would be common to use the main application bundle. For CocoaPods or framework distribution
a reference to an `NSBundle` can be provided.

### Creating the Migrations Table

```objc
FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:@"path/to/your/DB.sqlite" migrationsBundle:[NSBundle mainBundle]];
NSError *error = nil;
BOOL success = [manager createMigrationsTable:&error];
```

### Creating a SQL File Migration

```sh
$ touch "`ruby -e "puts Time.now.strftime('%Y%m%d%H%M%S%3N').to_i"`"_CreateMyAwesomeTable.sql
```

Now edit the file `*_CreateMyAwesomeTable.sql` in your editor of choice and add it to your application bundle.

### Creating an Objective-C Migration

Objective-C based migrations can be implemented by creating a new class that conforms the `FMDBMigrating` protocol:

```objc
@interface MyAwesomeMigration : NSObject <FMDBMigrating>
@end

@implementation MyAwesomeMigration

- (NSString *)name
{
    return @"My Object Migration";
}

- (uint64_t)version
{
    return 201499000000000;
}

- (BOOL)migrateDatabase:(FMDatabase *)database error:(out NSError *__autoreleasing *)error
{
	// Do something awesome
    return YES;
}

@end
```

When classes conforming to the `FMDBMigrating` protocol are added to the project they will be discovered by `FMDBMigrationManager` and considered for migration.

### Migrating a Database

```objc
FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:@"path/to/your/DB.sqlite" migrationsBundle:[NSBundle mainBundle]];
NSError *error = nil;
BOOL success = [manager migrateDatabaseToVersion:UINT64_MAX progress:nil error:&error];
```

### Inspecting Schema State

The `FMDBMigrationManager` includes a number of methods for investigating the state of your database. Here's a quick tour:

```objc
FMDBMigrationManager *manager = [FMDBMigrationManager managerWithDatabaseAtPath:@"path/to/your/DB.sqlite" migrationsBundle:[NSBundle mainBundle]];
NSLog(@"Has `schema_migrations` table?: %@", manager.hasMigrationsTable ? @"YES" : @"NO");
NSLog(@"Origin Version: %llu", manager.originVersion);
NSLog(@"Current version: %llu", manager.currentVersion);
NSLog(@"All migrations: %@", manager.migrations);
NSLog(@"Applied versions: %@", manager.appliedVersions);
NSLog(@"Pending versions: %@", manager.pendingVersions);
```

## Installation

FMDBMigrationManager is lightweight and depends only on SQLite and FMDB. As such, the library can be trivially be installed into any Cocoa project by directly adding the 
source code, linking against libsqlite, and including FMDB. Despite this fact, we recommend installing via CocoaPods as it provides modularity and easy version management.

### Via CocoaPods

The recommended approach for installing FMDBMigrationManager is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation. For best results, it is recommended that you install via CocoaPods **>= 0.31.0** using Git **>= 1.8.0** installed via Homebrew.

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project, and Create and Edit your Podfile and add FMDBMigrationManager:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
platform :ios, '5.0' 
# Or platform :osx, '10.7'
pod 'FMDBMigrationManager'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

### Via Source Code

Simply add `FMDBMigrationManager.h` and `FMDBMigrationManager.m` to your project and `#import "FMDBMigrationManager.h"`.

## Unit Tests

FMDBMigrationManager is tested using the [Expecta](https://github.com/specta/Expecta) library of unit testing matchers. In order to run the tests, you must do the following:

1. Install the dependencies via CocoaPods: `pod install`
1. Open the workspace: `open FMDBMigrationManager.xcworkspace`
1. Run the tests via the **Product** menu > **Test**

Alternately, you can run the tests on the commandline by installing the Ruby Gem dependencies. FMDBMigrationManager uses the [xctasks](http://github.com/layerhq/xctasks) Gem
to expose CLI automation on top of [Rake](https://github.com/jimweirich/rake). To run the tests on the CLI:

1. Install the dependencies: `bundle install`
1. Invoke Rake: `bundle exec rake test`

The Rake tasks are used to drive the continuous integration via Travis CI (see [.travis.yml]()).

## Credits

FMDBMigrationManager was lovingly crafted in San Francisco by Blake Watters during his work on [Layer](http://layer.com). At Layer, we are building the Communications Layer
for the Internet. We value, support, and create works of Open Source engineering excellence.

Blake Watters

- http://github.com/blakewatters
- http://twitter.com/blakewatters
- blakewatters@gmail.com

## License

FMDBMigrationManager is available under the Apache 2 License. See the LICENSE file for more info.
