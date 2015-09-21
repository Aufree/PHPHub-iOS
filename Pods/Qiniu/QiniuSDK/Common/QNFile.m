//
//  QNFile.m
//  QiniuSDK
//
//  Created by bailong on 15/7/25.
//  Copyright (c) 2015年 Qiniu. All rights reserved.
//

#import "QNFile.h"
#import "QNResponseInfo.h"

@interface QNFile ()

@property (nonatomic, readonly) NSString *filepath;

@property (nonatomic) NSData *data;

@property (readonly)  int64_t fileSize;

@property (readonly)  int64_t fileModifyTime;

@property (nonatomic) NSFileHandle *file;

@end

@implementation QNFile

- (instancetype)init:(NSString *)path
               error:(NSError *__autoreleasing *)error {
	if (self = [super init]) {
		_filepath = path;
		NSError *error2 = nil;
		NSDictionary *fileAttr = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error2];
		if (error2 != nil) {
			if (error != nil) {
				*error = error2;
			}
			return self;
		}
		NSNumber *fileSizeNumber = fileAttr[NSFileSize];
		_fileSize = [fileSizeNumber intValue];
		NSDate *modifyTime = fileAttr[NSFileModificationDate];
		int64_t t = 0;
		if (modifyTime != nil) {
			t = [modifyTime timeIntervalSince1970];
		}
		_fileModifyTime = t;
		NSFileHandle *f = nil;
		NSData *d = nil;
		//[NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:&error] 不能用在大于 200M的文件上，改用filehandle
		// 参见 https://issues.apache.org/jira/browse/CB-5790
		if (_fileSize > 16*1024*1024) {
			f = [NSFileHandle fileHandleForReadingAtPath:path];
			if (f == nil) {
				if (error != nil) {
					*error =[[NSError alloc] initWithDomain:path code:kQNFileError userInfo:nil];
				}
				return self;
			}
		}else{
			d = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error2];
			if (error2 != nil) {
				if (error != nil) {
					*error = error2;
				}
				return self;
			}
		}
		_file = f;
		_data = d;
	}

	return self;
}

- (NSData *)read:(long)offset
            size:(long)size {
	if (_data != nil) {
		return [_data subdataWithRange:NSMakeRange(offset, (unsigned int)size)];
	}
	[_file seekToFileOffset:offset];
	return [_file readDataOfLength:size];
}

- (NSData *)readAll {
	return [self read:0 size:(long)_fileSize];
}

- (void)close {
	if (_file != nil) {
		[_file closeFile];
	}
}

-(NSString *)path {
	return _filepath;
}

- (int64_t)modifyTime {
	return _fileModifyTime;
}

- (int64_t)size {
	return _fileSize;
}

@end
