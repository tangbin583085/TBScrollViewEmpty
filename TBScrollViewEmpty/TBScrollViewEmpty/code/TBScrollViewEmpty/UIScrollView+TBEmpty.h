//
//  UIScrollView+TBEmpty.h
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBSrollViewEmptyDelegate <NSObject>

@optional

// 是否显示emptyView
- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView;

// 顶部的image
- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView;

// 标题
- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView;

// 详情
- (NSAttributedString *)tb_emptyDetial:(UIScrollView *)scrollView;

// 底部按钮标题
- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView forState:(UIControlState)state;

// 底部按钮image
- (UIImage *)tb_emptyButtonImage:(UIScrollView *)scrollView forState:(UIControlState)state;

// emptyView 偏移量
- (UIEdgeInsets)tb_emptyViewInset:(UIScrollView *)scrollView;

// 自定义的emptyView
- (UIView *)tb_emptyView:(UIScrollView *)scrollView;

@end

@interface UIScrollView (TBEmpty)

@property (nonatomic, assign)id<TBSrollViewEmptyDelegate> tb_EmptyDelegate; // 代理

@end

