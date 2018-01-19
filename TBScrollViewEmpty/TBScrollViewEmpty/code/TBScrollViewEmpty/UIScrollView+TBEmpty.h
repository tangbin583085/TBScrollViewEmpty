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

// 显示emptyView
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

// 顶部的image
- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

// 标题
- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

// 详情
- (NSAttributedString *)tb_emptyDetial:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

// 底部按钮标题
- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

// 底部按钮点击事件
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status;

// emptyView 偏移量
- (UIEdgeInsets)tb_emptyViewInset:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

// 自定义的emptyView
- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status;

@end

@interface UIScrollView (TBEmpty) <TBEmptyViewDelegate>

@property (nonatomic, assign)id<TBSrollViewEmptyDelegate> tb_EmptyDelegate; // 代理

@end

