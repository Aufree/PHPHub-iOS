//
//  APIConstant.h
//  PHPHub
//
//  Created by Aufree on 9/30/15.
//  Copyright (c) 2015 ESTGroup. All rights reserved.
//

#define APIAccessTokenURL [NSString stringWithFormat:@"%@%@", APIBaseURL, @"/oauth/access_token"]
#define QiniuUploadTokenIdentifier @"QiniuUploadTokenIdentifier"

#if DEBUG
#define APIBaseURL      @"https://staging_api.phphub.org"
#else
#define APIBaseURL      @"https://api.phphub.org"
#endif

#define PHPHubHost      @"phphub.org"
#define PHPHubUrl       @"https://phphub.org/"
#define GitHubURL       @"https://github.com/"
#define TwitterURL      @"https://twitter.com/"
#define ProjectURL      @"https://github.com/phphub/phphub-ios"
#define AboutPageURL    @"https://phphub.org/about"
#define ESTGroupURL     @"http://est-group.org"
#define PHPHubGuide     @"http://7xnqwn.com1.z0.glb.clouddn.com/index.html"
#define PHPHubTopicURL  @"https://phphub.org/topics/"
#define SinaRedirectURL @"http://sns.whalecloud.com/sina2/callback"

#define UpdateNoticeCount @"UpdateNoticeCount"