//
//  APIConstant.h
//  PHPHub
//
//  Created by Aufree on 9/21/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#define Client_id                @"get client from server"
#define Client_secret            @"get client secret from server"
#define APIAccessToken [NSString stringWithFormat:@"%@%@", APIBaseURL, @"oauth/access_token"]

#define APIBaseURL                 @"https://api.phphub.org"
#define APIClientTokenIdentifier   @"APIClientTokenIdentifier"
#define APIPasswordTokenIdentifier @"APIPasswordTokenIdentifier"
#define QiniuUploadTokenIdentifier @"QiniuUploadTokenIdentifier"

#define UMENG_APPKEY @"560302ff67e58e882f002336"