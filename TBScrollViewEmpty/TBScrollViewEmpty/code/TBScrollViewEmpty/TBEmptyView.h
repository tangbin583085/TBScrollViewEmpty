//
//  TBEmptyView.h
//  TBScrollViewEmpty
//
//  Created by hanchuangkeji on 2018/1/18.
//  Copyright © 2018年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBNetworkReachability.h"

@protocol TBEmptyViewDelegate <NSObject>

// 点击代理
- (void)btnClick:(UIButton *)btn;

@end

@interface TBEmptyView : UIView

@property (nonatomic, assign)id<TBEmptyViewDelegate> delegate; // 代理

// 设置顶部图片
- (void)setImageView:(UIImage *)image network:(TBNetworkStatus)status isShow:(BOOL)show;

// 设置标题
- (void)setTitltString:(NSAttributedString *)attrString network:(TBNetworkStatus)status isShow:(BOOL)show;

// 设置详情
- (void)setDetailString:(NSAttributedString *)attrString network:(TBNetworkStatus)status isShow:(BOOL)show;

// 设置按钮
- (void)setButonTitle:(NSAttributedString *)titleAttrString network:(TBNetworkStatus)status isShow:(BOOL)show;

@end
