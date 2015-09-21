# MTLFMDBAdapter

[![CI Status](http://img.shields.io/travis/tanis2000/MTLFMDBAdapter.svg?style=flat)](https://travis-ci.org/tanis2000/MTLFMDBAdapter)
[![Version](https://img.shields.io/cocoapods/v/MTLFMDBAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLFMDBAdapter)
[![License](https://img.shields.io/cocoapods/l/MTLFMDBAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLFMDBAdapter)
[![Platform](https://img.shields.io/cocoapods/p/MTLFMDBAdapter.svg?style=flat)](http://cocoadocs.org/docsets/MTLFMDBAdapter)

**MTLFMDBAdapter** is a Mantle adapter that can serialize to and from FMDB (SQLite).
What this all boils down to is being able to create an MTLModel instance by feeding an FMResultSet and vice versa create the INSERT/UPDATE/DELETE statements to store the object in FMDB.

## Why?

I have been using Core Data and RestKit for in many commercial projects but I've never been satisfied with the results. Core Data is slow and it's hard to get right when working with different threads. RestKit is great and it works fine with RESTful services but it's not good when you need to talk to web services that do not adhere to the REST protocol or that diverge in some way. So this has become the base for my own web service to object model mapping. I adopted Mantle as it's got all the features I need and it works way better than what I originally coded, so it was kind of natural to add it to my toolbelt. 
I also love to work directly with SQL statements and SQLite has always been my solution of choice for new projects. FMDB is a thin layer of code on top of SQLite that simplifies common tasks like managing threads (queues).
This adapter fills the gap between Mantle and FMDB. 

Contributions and Pull Requests are welcome!

## Quick start

Here's a quick example of how to use this library

```obj-c
// Grab the Documents folder
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
NSString *documentsDirectory = [paths objectAtIndex:0];
        
// Sets the database filename
NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"MTLFMDBTests.sqlite"];
        
// Tell FMDB where the database is
db = [FMDatabase databaseWithPath:filePath];
// Open the database
[db open];

// Remove the tables if they're already there. You won't usually do this in real life applications
[db executeUpdate:@"drop table if exists user"];
[db executeUpdate:@"drop table if exists repository"];

// Create the tables we're going to work with
[db executeUpdate:@"create table if not exists user "
    "(guid text primary key, name text, age integer)"];
[db executeUpdate:@"create table if not exists repository "
    "(guid text primary key, url text)"];
    
// An empty model we will fill with the record retrieved from the database
MTLFMDBMockUser *resultUser = nil;
// The initial model we will write to the database
MTLFMDBMockUser *user = [[MTLFMDBMockUser alloc] init];
user.guid = @"myuniqueid";
user.name = @"John Doe";
user.age = [NSNumber numberWithInt:42];
        
// Create the INSERT statement
NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
// Get the values of the record in a format we can use with FMDB
NSArray *params = [MTLFMDBAdapter columnValues:user];
// Execute our INSERT
[db executeUpdate:stmt withArgumentsInArray:params];

// Read the record we've just written to the database        
NSError *error = nil;
FMResultSet *resultSet = [db executeQuery:@"select * from user"];
if ([resultSet next]) {
    resultUser = [MTLFMDBAdapter modelOfClass:MTLFMDBMockUser.class fromFMResultSet:resultSet error:&error];
}

```

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### Defining a model

A model can be defined using the standard Mantle way. To add support for FMDB serialization you have to add the `<MTLFMDBSerializing>` protocol.

```obj-c
	#import "MTLModel.h"
	#import <Mantle/Mantle.h>
	#import <MTLFMDBAdapter/MTLFMDBAdapter.h>

	@interface MTLFMDBMockUser : MTLModel<MTLFMDBSerializing>

	@property (nonatomic, copy) NSString *guid;
	@property (nonatomic, copy) NSString *name;
	@property (nonatomic, copy) NSNumber *age;
	@property (nonatomic, copy) NSSet *repositories;

	@end
```

`<MTLFMDBSerializing>` requires a few methods to be implemented in your model's code.

```obj-c
	#import "MTLFMDBMockUser.h"

	@implementation MTLFMDBMockUser

	+ (NSDictionary *)FMDBColumnsByPropertyKey
	{
	    return @{
	             @"guid": @"guid",
	             @"name": @"name",
	             @"age": @"age",
	             @"repositories": [NSNull null],
	             };
	}

	+ (NSArray *)FMDBPrimaryKeys
	{
	    return @[@"guid"];
	}

	+ (NSString *)FMDBTableName {
	    return @"user";
	}
```

### Getting the INSERT statement for a model

```obj-c
	NSString *stmt = [MTLFMDBAdapter insertStatementForModel:user];
```

If `user` is an instance of the `MTLFMDBMockUser` class we defined up there, the result will be

```sql
	insert into user (age, guid, name) values (?, ?, ?)
```

### Getting the values for an INSERT statement for a model

```obj-c
NSArray *params = [MTLFMDBAdapter columnValues:user];
```

This will return an array with the values of the three columns in the same order as the column names of the statement (always alphabetical order)

## Requirements

MTLFMDBAdapter requires [Mantle](https://github.com/Mantle/Mantle) as a dependency.

## Installation

MTLFMDBAdapter is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MTLFMDBAdapter"

## Author

Valerio Santinelli, santinelli@altralogica.it

## License

MTLFMDBAdapter is available under the MIT license. See the LICENSE file for more info.

