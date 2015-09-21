//
//  QNFileRecorder.m
//  QiniuSDK
//
//  Created by bailong on 14/10/5.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "QNFileRecorder.h"
#import "QNUrlSafeBase64.h"

@interface QNFileRecorder  ()

@property (copy, readonly) NSString *directory;
@property BOOL encode;

@end

@implementation QNFileRecorder

- (NSString *)pathOfKey:(NSString *)key {
	return [QNFileRecorder pathJoin:key path:_directory];
}

+ (NSString *)pathJoin:(NSString *)key
                  path:(NSString *)path {
	return [[NSString alloc] initWithFormat:@"%@/%@", path, key];
}

+ (instancetype)fileRecorderWithFolder:(NSString *)directory
                                 error:(NSError *__autoreleasing *)perror {
	return [QNFileRecorder fileRecorderWithFolder:directory encodeKey:false error:perror];
}

+ (instancetype)fileRecorderWithFolder:(NSString *)directory
                             encodeKey:(BOOL)encode
                                 error:(NSError *__autoreleasing *)perror {
	NSError *error;
	[[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
	if (error != nil) {
		if (perror) {
			*perror = error;
		}
		return nil;
	}

	return [[QNFileRecorder alloc] initWithFolder:directory encodeKey:encode];
}

- (instancetype)initWithFolder:(NSString *)directory encodeKey:(BOOL)encode {
	if (self = [super init]) {
		_directory = directory;
		_encode = encode;
	}
	return self;
}

- (NSError *)set:(NSString *)key
            data:(NSData *)value {
	NSError *error;
	if (_encode) {
		key = [QNUrlSafeBase64 encodeString:key];
	}
	[value writeToFile:[self pathOfKey:key] options:NSDataWritingAtomic error:&error];
	return error;
}

- (NSData *)get:(NSString *)key {
	if (_encode) {
		key = [QNUrlSafeBase64 encodeString:key];
	}
	return [NSData dataWithContentsOfFile:[self pathOfKey:key]];
}

- (NSError *)del:(NSString *)key {
	NSError *error;
	if (_encode) {
		key = [QNUrlSafeBase64 encodeString:key];
	}
	[[NSFileManager defaultManager] removeItemAtPath:[self pathOfKey:key] error:&error];
	return error;
}

+ (void)removeKey:(NSString *)key
        directory:(NSString *)dir
        encodeKey:(BOOL)encode {
	if (encode) {
		key = [QNUrlSafeBase64 encodeString:key];
	}
	NSError *error;
	NSString *path = [QNFileRecorder pathJoin:key path:dir];
	[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p, dir: %@>", NSStringFromClass([self class]), self, _directory];
}

@end
