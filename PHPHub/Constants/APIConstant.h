//
//  APIConstant.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#define APIAccessToken [NSString stringWithFormat:@"%@%@", APIBaseURL, @"oauth/access_token"]

#define APIBaseURL                 @"https://api.phphub.org"
#define APIClientTokenIdentifier   @"APIClientTokenIdentifier"
#define APIPasswordTokenIdentifier @"APIPasswordTokenIdentifier"
#define QiniuUploadTokenIdentifier @"QiniuUploadTokenIdentifier"