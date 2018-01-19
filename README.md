TBScrollViewEmpty
==============

[![License](http://img.shields.io/badge/license-MIT-blue.svg)](http://opensource.org/licenses/MIT)&nbsp;
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/v/YYKit.svg?style=flat)](http://cocoapods.org/pods/YYKit)&nbsp;
[![CocoaPods](http://img.shields.io/cocoapods/p/YYKit.svg?style=flat)](http://cocoadocs.org/docsets/YYKit)&nbsp;
[![Support](https://img.shields.io/badge/support-iOS%206%2B%20-blue.svg?style=flat)](https://www.apple.com/nl/ios/)&nbsp;
[![Build Status](https://travis-ci.org/ibireme/YYKit.svg?branch=master)](https://travis-ci.org/ibireme/YYKit)


What
==============
Traditionally we use list component (UITableView or CollectionView) to show content. However, those components may display blank when the data is empty, specially for new users with accounts, the network is not reachable or something wrong with our app. To let the users konw what is going on when the blank comes out, it’s necessary for empty states to be dealt with by developers as blank pages often caused by exceptions.

Installation
==============

### Install

1. Add `pod 'TBScrollViewEmpty'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<TBScrollViewEmpty.h\>.

Feature
==============
- **Automatic**: Automatically add or move the tip view.
- **Structure**: This framework allows you customized development easily.
- **Network**: Monitor the state of network.
- **NSAttributedString**: Uses NSAttributedString for easier appearance customisation.

Demo
==============
this is a gif

How to use
==============
Conform to datasource and/or delegate.
```objc
@interface MainViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
}
```

License
==============
TBScrollViewEmpty is provided under the MIT license. See LICENSE file for details.

Company and Organization
==============
@Shanghai,HC&nbsp;&nbsp;&nbsp;@Shanghai,HK

<br/><br/>
---

中文介绍
==============

简介
==============
我们往往会使用列表组件(UITableView or CollectionView) 来展示App内容。但是，这些组件在数据为空的时候有可能会出现空白页，特别当新账号用户，网络异常或者App出现bug。为了让用户清楚了解空白页的情况，开发者很有必要对那些常由异常造成的空白页，给出温馨提示和引导视图。

安装
==============

### 安装

1. Add `pod 'TBScrollViewEmpty'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<TBScrollViewEmpty.h\>.

特性
==============
- **自动化**: 自动添加或移除提示视图.
- **结构**: 该框架可以使你快速自定义视图.
- **网络**: 监听网络状态变化.
- **NSAttributedString**: 使用NSAttributedString可以更加快速建立视图表达.

Demo
==============
this is a gif

如何用
==============
Conform to datasource and/or delegate.
```objc
@interface MainViewController : UITableViewController <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];
}
```

授权
==============
TBScrollViewEmpty完全公开源代码给开发者使用，无抄袭任何框架代码。
使用TBScrollViewEmpty应遵守MIT协议. 详情见协议文件。

Company and Organization
==============
@Shanghai,HC&nbsp;&nbsp;&nbsp;@Shanghai,HK
