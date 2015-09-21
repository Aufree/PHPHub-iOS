#import <Foundation/Foundation.h>
#import "QNHttpDelegate.h"

#import "QNConfiguration.h"

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090)

@interface QNSessionManager : NSObject <QNHttpDelegate>

- (instancetype)initWithProxy:(NSDictionary *)proxyDict
                      timeout:(UInt32)timeout
                 urlConverter:(QNUrlConvert)converter
                          dns:(QNDnsManager*)dns;

- (void)    multipartPost:(NSString *)url
                 withData:(NSData *)data
               withParams:(NSDictionary *)params
             withFileName:(NSString *)key
             withMimeType:(NSString *)mime
        withCompleteBlock:(QNCompleteBlock)completeBlock
        withProgressBlock:(QNInternalProgressBlock)progressBlock
          withCancelBlock:(QNCancelBlock)cancelBlock;

- (void)             post:(NSString *)url
                 withData:(NSData *)data
               withParams:(NSDictionary *)params
              withHeaders:(NSDictionary *)headers
        withCompleteBlock:(QNCompleteBlock)completeBlock
        withProgressBlock:(QNInternalProgressBlock)progressBlock
          withCancelBlock:(QNCancelBlock)cancelBlock;

@end

#endif
