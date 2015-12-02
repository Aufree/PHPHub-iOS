<p align="center">
<img src="http://ww4.sinaimg.cn/large/76dc7f1bgw1eyfw7ewb0nj20q808774z.jpg" alt="PHPHub-iOS" title="PHPHub-iOS" width="1000"/>
</p>

<p align="center">
<a href="https://weibo.com/jinfali"><img src="https://img.shields.io/badge/contact-@Aufree-orange.svg?style=flat"></a>
<a href="https://itunes.apple.com/us/app/phphub-ji-ji-xiang-shang-php/id1052966564"><img src="https://img.shields.io/badge/App%20Store-%EF%A3%BF%20Download-blue.svg"></a>
<a href="https://github.com/Aufree/phphub-ios/blob/master/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green.svg?style=flat"></a>
</p>


PHPHub is a Forum project written in Laravel 4.2, and it is also the project build up PHP & Laravel China community.

PHPHub for iOS is the universal iPhone and iPad application for [PHPHub](https://phphub.org/), This is the official PHPHub iOS client that uses the newly introduced official [PHPHub API](https://github.com/NauxLiu/phphub-server), One of the cool features of the new API are updates pushed in real time.

If you have any questions please don't hesitate to ask them in an issue or email me at phphub.org@gmail.com.

**Our team is EST Group, Check out [this link](http://www.est-group.org) if you want to know more details.**


## PHPHub related projects

You can checkout the others open source projects of PHPHub in the following list.

* [PHPHub-Server](https://github.com/NauxLiu/phphub-server) by [@NauxLiu](https://github.com/NauxLiu)
* [PHPHub-Android](https://github.com/CycloneAxe/phphub-android) by [@Kelvin](https://github.com/CycloneAxe) and [@Xiaoxiaoyu](https://github.com/xiaoxiaoyu)
* [PHPHub-UI](https://github.com/phphub/phphub-ui) by [@Summer](https://github.com/phphub/phphub-ui) and [@Aufree](https://github.com/aufree)
* [PHPHub-Web](https://github.com/summerblue/phphub) by [@Summer](https://github.com/phphub/phphub-ui)


## [中文文档](http://aufree.github.io/phphub-ios/)

## Features

- [x] Support the iPhone and the iPad perfectly
- [x] Integrate Google Analytics
- [x] Support User Feedback ([UMeng](umeng.com))
- [x] Apple Push Notification Service ([Jpush](https://www.jpush.cn))
- [x] Social Share ([UMeng](umeng.com))
- [x] Crash Reporting (Crashlytics)
- [x] Data Persistence (User Model)
- [x] Launch Screen Ads
- [x] Scan to login ([QRCodeReaderViewController](https://github.com/zhengjinghua/MQRCodeReaderViewController))
- [x] Full screen Pop Gesture ([FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture))
- [x] Open images of web view in-app ([JTSImageViewController](https://github.com/jaredsinclair/JTSImageViewController)]

## Screenshots

### iPhone

![](http://7fvhf5.com1.z0.glb.clouddn.com/phphub-iphone.png)

### iPad

![](http://ww4.sinaimg.cn/large/006fiYtfgw1exknd0wca7j31kw1ff4b8.jpg)

## Requirements

* An iPhone/iPad running iOS 8.0+
* Xcode 7.0 or above

## Build Instructions

If you're not install the Cocoapods on your machine, Run:

> $ gem install cocoapods
> $ pod setup

Download the source code

> $ git clone https://github.com/Aufree/phphub-ios

Now you'll need to build the dependencies

> $ pod install

Next you'll need to create your own version of environment-specific data. Make a copy of SecretConstant.example.h as SecretConstant.h:

> $ cp PHPHub/Constants/SecretConstant.example.h PHPHub/Constants/SecretConstant.h

Open `PHPHub.xcworkspace` in Xcode.

**Note: Don't open the .xcodeproj because we use Cocoapods now!**

Now you need to apply for a `Client_id` and a `Client_secret` in [this link](#) (Use in production environments).

Open `SecretConstant.h` and set it up.

Run this command to create a plist file for Jpush.

> $ cp PHPHub/PushConfig.example.plist PHPHub/PushConfig.plist

You can setup your Jpush appkey in `PHPHub/PushConfig.plist` if you want to use Jpush.

Run the application in the debug mode.

Select Product -> Scheme -> Edit Schemes -> Info -> Change Build Configuration to Debug mode.

**Important: You shouldn't test your code in production environment!**

That's it! Have Fun! :beers:

## How should I Login?

### Development Environment

Scan this QRCode by using PHPHub for iOS application.

![](http://ww3.sinaimg.cn/large/76dc7f1bgw1exrg86f5ubj20ml0dsq45.jpg)

### Production Environment

Go to [PHPHub's official website](https://phphub.org) and Login with GitHub. then find your QRCode in your personal page. It should look like this:
 
 ![](http://ww2.sinaimg.cn/large/006fiYtfgw1exn0vweimxj31kw11316f.jpg)

## Who made this

I'm [Aufree](https://github.com/aufree), A passionate engineer, leading member of [The EST Group](http://www.est-group.org), and while I am college dropout, I want to make some cool stuff in GitHub, That's why I'm here, you can ping me on [Twitter](https://twitter.com/_Paul_King_) or follow me on [Weibo](http://weibo.com/jinfali) If you find an issue.

## Contributers

* [@Aufree](https://github.com/aufree) - An engineer love of technology.
* [@Moneky](https://github.com/zhengjinghua/) - Amazing guy. 
* [@Summer](https://github.com/summerblue) - The only true man I have always admire, this guy can do anything. 

## Contributing

Thank you for your interest in contributing to PHPHub for iOS! Your ideas for improving this app are greatly appreciated. The best way to contribute is by submitting a pull request. I'll do my best to respond to you as soon as possible. You can also [submit a new GitHub issue](https://github.com/Aufree/phphub-ios/issues/new) if you find bugs or have questions.

## Third-party Libraries

This software additionally references or incorporates the following sources of intellectual property, the license terms for which are set forth in the sources themselves:

The following dependencies are bundled with the PHPHub, but are under terms of a separate license:

Project | Introduction
--------- | ---------------
[MJRefresh](https://github.com/CoderMJLee/MJRefresh) | An easy way to use pull-to-refresh
[Qiniu](https://github.com/vitoziv/Qiniu-iOS-SDK) | Qiniu cloud iOS SDK
[DateTools](https://github.com/MatthewYork/DateTools) | Dates and times made easy in Objective-C
[GVUserDefaults](https://github.com/gangverk/GVUserDefaults) | NSUserDefaults access via properties.
[FDFullscreenPopGesture](https://github.com/forkingdog/FDFullscreenPopGesture) | An UINavigationController's category to enable fullscreen pop gesture in an iOS7+ system style with AOP.
[UIActionSheet+Blocks](https://github.com/ryanmaxwell/UIActionSheet-Blocks) | Category on UIActionSheet to use inline block callbacks instead of delegate callbacks.

For a more complete list, check the [Podfile](https://github.com/Aufree/phphub-ios/blob/master/Podfile).

## Thanks for

* [@GitHubDaily](http://weibo.com/GitHubDaily)
* [@开发者头条](http://weibo.com/kaifazhetoutiao)
* [@稀土圈](http://weibo.com/xitucircle)
* [@好东西传送门](http://weibo.com/haoawesome)
* [@极客头条](http://weibo.com/csdngeek)

## License

Copyright (c) 2015 Paul King

---------------

Released under the [MIT license](https://github.com/Aufree/phphub-ios/blob/master/LICENSE)
