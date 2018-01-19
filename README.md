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
TBScrollViewEmpty
==============

简介
==============
Traditionally we use list component (UITableView or CollectionView) to show content. However, those components may display blank when the data is empty, specially for new users with accounts, the network is not reachable or something wrong with our app. To let the users konw what is going on when the blank comes out, it’s necessary for empty states to be dealt with by developers as blank pages often caused by exceptions.

安装
==============

### 安装

1. Add `pod 'TBScrollViewEmpty'` to your Podfile.
2. Run `pod install` or `pod update`.
3. Import \<TBScrollViewEmpty.h\>.

特性
==============
- **Automatic**: Automatically add or move the tip view.
- **Structure**: This framework allows you customized development easily.
- **Network**: Monitor the state of network.
- **NSAttributedString**: Uses NSAttributedString for easier appearance customisation.

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
TBScrollViewEmpty is provided under the MIT license. See LICENSE file for details.

Company and Organization
==============
@Shanghai,HC&nbsp;&nbsp;&nbsp;@Shanghai,HK
