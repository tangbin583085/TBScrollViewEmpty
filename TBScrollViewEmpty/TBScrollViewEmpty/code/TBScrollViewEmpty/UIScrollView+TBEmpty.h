//
//  UIScrollView+TBEmpty.h
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBEmptyView.h"
#import "TBNetworkReachability.h"

@protocol TBSrollViewEmptyDelegate <NSObject>

@optional

/**
 显示emptyView

 @param scrollView tableView或者collectionView
 @param status 网络状态
 @return 是否启用emptyView，默认为YES
 */
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

/**
 顶部的image
 
 @param scrollView tableView或者collectionView
 @param status 网络状态
 @return 顶部图片，默认显示，如果返回nil则隐藏
 */
- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

/**
 标题
 
 @param scrollView tableView或者collectionView
 @param status 网络状态
 @return 标题，默认显示，如果返回nil则隐藏，如果返回的NSAttributedString string为了@""则使用框架默认string
 */
- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

/**
 详情
 
 @param scrollView tableView或者collectionView
 @param status 网络状态
 @return 标题，默认显示，如果返回nil则隐藏，如果返回的NSAttributedString string为了@""则使用框架默认string
 */
- (NSAttributedString *)tb_emptyDetial:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

/**
 底部按钮标题
 
 @param scrollView tableView或者collectionView
 @param status 网络状态
 @return 按钮标题，默认不显示，如果返回NSAttributedString不为空则显示，如果返回的NSAttributedString string为了@""则使用框架默认string
 */
- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

/**
 底部按钮点击事件

 @param btn 按钮
 @param status 网络状态
 */
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status;

/**
 emptyView 偏移量

 @param scrollView tableView或者collectionView
 @param status 网络状态
 @return 偏移的point
 */
- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

/**
 自定义的emptyView

 @param scrollView tableView或者collectionView
 @param status 网络状态
 @return 返回返回对象不为空，则优先显示自定义View，隐藏框架默认提供的emptyView
 */
- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

@end

@interface UIScrollView (TBEmpty) <TBEmptyViewDelegate>

@property (nonatomic, assign)id<TBSrollViewEmptyDelegate> tb_EmptyDelegate; // 代理

@end

