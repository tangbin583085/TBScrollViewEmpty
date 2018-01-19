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

- (void)btnClick:(UIButton *)btn;

@end

@interface TBEmptyView : UIView

@property (nonatomic, assign)id<TBEmptyViewDelegate> delegate; // 代理

- (void)setImageView:(UIImage *)image network:(TBNetworkStatus)status isShow:(BOOL)show;

- (void)setTitltString:(NSAttributedString *)attrString network:(TBNetworkStatus)status isShow:(BOOL)show;

- (void)setDetailString:(NSAttributedString *)attrString network:(TBNetworkStatus)status isShow:(BOOL)show;

- (void)setButonTitle:(NSAttributedString *)titleAttrString network:(TBNetworkStatus)status isShow:(BOOL)show;

@end
