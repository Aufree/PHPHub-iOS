//
//  QNResumeUpload.m
//  QiniuSDK
//
//  Created by bailong on 14/10/1.
//  Copyright (c) 2014年 Qiniu. All rights reserved.
//

#import "QNResumeUpload.h"
#import "QNUploadManager.h"
#import "QNUrlSafeBase64.h"
#import "QNConfiguration.h"
#import "QNResponseInfo.h"
#import "QNHttpManager.h"
#import "QNUploadOption+Private.h"
#import "QNRecorderDelegate.h"
#import "QNCrc32.h"

typedef void (^task)(void);

@interface QNResumeUpload ()

@property (nonatomic, strong) id <QNHttpDelegate> httpManager;
@property UInt32 size;
@property (nonatomic) int retryTimes;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *recorderKey;
@property (nonatomic) NSDictionary *headers;
@property (nonatomic, strong) QNUploadOption *option;
@property (nonatomic, strong) QNUpToken *token;
@property (nonatomic, strong) QNUpCompletionHandler complete;
@property (nonatomic, strong) NSMutableArray *contexts;

@property int64_t modifyTime;
@property (nonatomic, strong) id <QNRecorderDelegate> recorder;

@property (nonatomic, strong) QNConfiguration *config;

@property UInt32 chunkCrc;

@property (nonatomic, strong) id <QNFileDelegate> file;

- (void)makeBlock:(NSString *)uphost
           offset:(UInt32)offset
        blockSize:(UInt32)blockSize
        chunkSize:(UInt32)chunkSize
         progress:(QNInternalProgressBlock)progressBlock
         complete:(QNCompleteBlock)complete;

- (void)putChunk:(NSString *)uphost
          offset:(UInt32)offset
            size:(UInt32)size
         context:(NSString *)context
        progress:(QNInternalProgressBlock)progressBlock
        complete:(QNCompleteBlock)complete;

- (void)makeFile:(NSString *)uphost
        complete:(QNCompleteBlock)complete;

@end

@implementation QNResumeUpload

- (instancetype) initWithFile:(id <QNFileDelegate> )file
                      withKey:(NSString *)key
                    withToken:(QNUpToken *)token
        withCompletionHandler:(QNUpCompletionHandler)block
                   withOption:(QNUploadOption *)option
                 withRecorder:(id <QNRecorderDelegate> )recorder
              withRecorderKey:(NSString *)recorderKey
              withHttpManager:(id <QNHttpDelegate> )http
            withConfiguration:(QNConfiguration *)config;
{
	if (self = [super init]) {
		_file = file;
		_size = (UInt32)[file size];
		_key = key;
		NSString *tokenUp = [NSString stringWithFormat:@"UpToken %@", token.token];
		_option = option != nil ? option :[QNUploadOption defaultOptions];
		_complete = block;
		_headers = @{ @"Authorization":tokenUp, @"Content-Type":@"application/octet-stream" };
		_recorder = recorder;
		_httpManager = http;
		_modifyTime = [file modifyTime];
		_recorderKey = recorderKey;
		_contexts = [[NSMutableArray alloc] initWithCapacity:(_size + kQNBlockSize - 1) / kQNBlockSize];
		_config = config;

		_token = token;
	}
	return self;
}

// save json value
//{
//    "size":filesize,
//    "offset":lastSuccessOffset,
//    "modify_time": lastFileModifyTime,
//    "contexts": contexts
//}

- (void)record:(UInt32)offset {
	NSString *key = self.recorderKey;
	if (offset == 0 || _recorder == nil || key == nil || [key isEqualToString:@""]) {
		return;
	}
	NSNumber *n_size = @(self.size);
	NSNumber *n_offset = @(offset);
	NSNumber *n_time = [NSNumber numberWithLongLong:_modifyTime];
	NSMutableDictionary *rec = [NSMutableDictionary dictionaryWithObjectsAndKeys:n_size, @"size", n_offset, @"offset", n_time, @"modify_time", _contexts, @"contexts", nil];

	NSError *error;
	NSData *data = [NSJSONSerialization dataWithJSONObject:rec options:NSJSONWritingPrettyPrinted error:&error];
	if (error != nil) {
		NSLog(@"up record json error %@ %@", key, error);
		return;
	}
	error = [_recorder set:key data:data];
	if (error != nil) {
		NSLog(@"up record set error %@ %@", key, error);
	}
}

- (void)removeRecord {
	if (_recorder == nil) {
		return;
	}
	[_recorder del:self.recorderKey];
}

- (UInt32)recoveryFromRecord {
	NSString *key = self.recorderKey;
	if (_recorder == nil || key == nil || [key isEqualToString:@""]) {
		return 0;
	}

	NSData *data = [_recorder get:key];
	if (data == nil) {
		return 0;
	}

	NSError *error;
	NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
	if (error != nil) {
		NSLog(@"recovery error %@ %@", key, error);
		[_recorder del:self.key];
		return 0;
	}
	NSNumber *n_offset = info[@"offset"];
	NSNumber *n_size = info[@"size"];
	NSNumber *time = info[@"modify_time"];
	NSArray *contexts = info[@"contexts"];
	if (n_offset == nil || n_size == nil || time == nil || contexts == nil) {
		return 0;
	}

	UInt32 offset = [n_offset unsignedIntValue];
	UInt32 size = [n_size unsignedIntValue];
	if (offset > size || size != self.size) {
		return 0;
	}
	UInt64 t = [time unsignedLongLongValue];
	if (t != _modifyTime) {
		NSLog(@"modify time changed %llu, %llu", t, _modifyTime);
		return 0;
	}
	_contexts = [[NSMutableArray alloc] initWithArray:contexts copyItems:true];
	return offset;
}

- (void)nextTask:(UInt32)offset retriedTimes:(int)retried host:(NSString *)host {
	if (self.option.cancellationSignal()) {
		self.complete([QNResponseInfo cancel], self.key, nil);
		return;
	}

	if (offset == self.size) {
		QNCompleteBlock completionHandler = ^(QNResponseInfo *info, NSDictionary *resp) {
			if (info.isOK) {
				[self removeRecord];
				self.option.progressHandler(self.key, 1.0);
			}
			else if (info.couldRetry && retried < _config.retryMax) {
				[self nextTask:offset retriedTimes:retried + 1 host:host];
				return;
			}
			self.complete(info, self.key, resp);
		};
		[self makeFile:host complete:completionHandler];
		return;
	}

	UInt32 chunkSize = [self calcPutSize:offset];
	QNInternalProgressBlock progressBlock = ^(long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		float percent = (float)(offset + totalBytesWritten) / (float)self.size;
		if (percent > 0.95) {
			percent = 0.95;
		}
		self.option.progressHandler(self.key, percent);
	};

	QNCompleteBlock completionHandler = ^(QNResponseInfo *info, NSDictionary *resp) {
		if (info.error != nil) {
			if (info.statusCode == 701) {
				[self nextTask:(offset / kQNBlockSize) * kQNBlockSize retriedTimes:0 host:host];
				return;
			}
			if (retried >= _config.retryMax || !info.couldRetry) {
				self.complete(info, self.key, resp);
				return;
			}

			NSString *nextHost = host;
			if (info.isConnectionBroken || info.needSwitchServer) {
				nextHost = _config.upHostBackup;
			}

			[self nextTask:offset retriedTimes:retried + 1 host:nextHost];
			return;
		}

		if (resp == nil) {
			[self nextTask:offset retriedTimes:retried host:host];
			return;
		}

		NSString *ctx = resp[@"ctx"];
		NSNumber *crc = resp[@"crc32"];
		if (ctx == nil || crc == nil || [crc unsignedLongValue] != _chunkCrc) {
			[self nextTask:offset retriedTimes:retried host:host];
			return;
		}
		_contexts[offset / kQNBlockSize] = ctx;
		[self record:offset + chunkSize];
		[self nextTask:offset + chunkSize retriedTimes:retried host:host];
	};
	if (offset % kQNBlockSize == 0) {
		UInt32 blockSize = [self calcBlockSize:offset];
		[self makeBlock:host offset:offset blockSize:blockSize chunkSize:chunkSize progress:progressBlock complete:completionHandler];
		return;
	}
	NSString *context = _contexts[offset / kQNBlockSize];
	[self putChunk:host offset:offset size:chunkSize context:context progress:progressBlock complete:completionHandler];
}

- (UInt32)calcPutSize:(UInt32)offset {
	UInt32 left = self.size - offset;
	return left < _config.chunkSize ? left : _config.chunkSize;
}

- (UInt32)calcBlockSize:(UInt32)offset {
	UInt32 left = self.size - offset;
	return left < kQNBlockSize ? left : kQNBlockSize;
}

- (void)makeBlock:(NSString *)uphost
           offset:(UInt32)offset
        blockSize:(UInt32)blockSize
        chunkSize:(UInt32)chunkSize
         progress:(QNInternalProgressBlock)progressBlock
         complete:(QNCompleteBlock)complete {
	NSData *data = [self.file read:offset size:chunkSize];
	NSString *url = [[NSString alloc] initWithFormat:@"http://%@:%u/mkblk/%u", uphost, (unsigned int)_config.upPort, (unsigned int)blockSize];
	_chunkCrc = [QNCrc32 data:data];
	[self post:url withData:data withCompleteBlock:complete withProgressBlock:progressBlock];
}

- (void)putChunk:(NSString *)uphost
          offset:(UInt32)offset
            size:(UInt32)size
         context:(NSString *)context
        progress:(QNInternalProgressBlock)progressBlock
        complete:(QNCompleteBlock)complete {
	NSData *data = [self.file read:offset size:size];
	UInt32 chunkOffset = offset % kQNBlockSize;
	NSString *url = [[NSString alloc] initWithFormat:@"http://%@:%u/bput/%@/%u", uphost, (unsigned int)_config.upPort, context, (unsigned int)chunkOffset];
	_chunkCrc = [QNCrc32 data:data];
	[self post:url withData:data withCompleteBlock:complete withProgressBlock:progressBlock];
}

- (void)makeFile:(NSString *)uphost
        complete:(QNCompleteBlock)complete {
	NSString *mime = [[NSString alloc] initWithFormat:@"/mimeType/%@", [QNUrlSafeBase64 encodeString:self.option.mimeType]];

	__block NSString *url = [[NSString alloc] initWithFormat:@"http://%@:%u/mkfile/%u%@", uphost, (unsigned int)_config.upPort, (unsigned int)self.size, mime];

	if (self.key != nil) {
		NSString *keyStr = [[NSString alloc] initWithFormat:@"/key/%@", [QNUrlSafeBase64 encodeString:self.key]];
		url = [NSString stringWithFormat:@"%@%@", url, keyStr];
	}

	[self.option.params enumerateKeysAndObjectsUsingBlock: ^(NSString *key, NSString *obj, BOOL *stop) {
	         url = [NSString stringWithFormat:@"%@/%@/%@", url, key, [QNUrlSafeBase64 encodeString:obj]];
	 }];


	NSMutableData *postData = [NSMutableData data];
	NSString *bodyStr = [self.contexts componentsJoinedByString:@","];
	[postData appendData:[bodyStr dataUsingEncoding:NSUTF8StringEncoding]];
	[self post:url withData:postData withCompleteBlock:complete withProgressBlock:nil];
}

- (void)             post:(NSString *)url
                 withData:(NSData *)data
        withCompleteBlock:(QNCompleteBlock)completeBlock
        withProgressBlock:(QNInternalProgressBlock)progressBlock {
	[_httpManager post:url withData:data withParams:nil withHeaders:_headers withCompleteBlock:completeBlock withProgressBlock:progressBlock withCancelBlock:_option.cancellationSignal];
}

- (void)run {
	@autoreleasepool {
		UInt32 offset = [self recoveryFromRecord];
		[self nextTask:offset retriedTimes:0 host:_config.upHost];
	}
}

@end
