## 项目介绍

此项目为 [PHPHub](https://phphub.org/) iOS客户端

## 用到的组件
#### 1、通过 CocoaPods 安装

项目名称 | 项目信息
------- | -------
[AFNetworking](https://github.com/AFNetworking/AFNetworking) | 网络请求组件
[FMDB](https://github.com/ccgus/fmdb) | 本地数据库组件
[SDWebImage](https://github.com/rs/SDWebImage) | 多个缩略图缓存组件
[Reachability](https://github.com/tonymillion/Reachability) | 监测网络状态
[MBProgressHUD](https://github.com/jdg/MBProgressHUD) | 一款提示框第三方库
[Mantle](https://github.com/Mantle/Mantle) | 主要用来将 JSON 数据模型化为 Model 对象
[MTLFMDBAdapter](https://github.com/tanis2000/MTLFMDBAdapter) | Mantle 和 FMDB 的转换工具
[FMDBMigrationManager](https://github.com/layerhq/FMDBMigrationManager) | 支持 iOS SQLite 数据库迁移
[GVUserDefaults](https://github.com/gangverk/GVUserDefaults) | 对 NSUserDefaults 进行了封装, 方便的进行本地化存储操作
[Masonry](https://github.com/SnapKit/Masonry) | 一个轻量级的布局框架, 用于替换官方的 AutoLayout 写法

 
## 安装方式
1、在指定的目录下执行  

>  git clone https://github.com/phphub/phphub-ios
  
2、在终端下进入项目根目录,执行以下命令安装 CocoaPods 组件

>  pod install

3、打开 PHPHub.xcworkspace 文件，直接编译运行