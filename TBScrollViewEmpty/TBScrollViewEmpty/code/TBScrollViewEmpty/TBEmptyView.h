//
//  TBEmptyView.h
//  TBScrollViewEmpty
//
//  Created by hanchuangkeji on 2018/1/18.
//  Copyright © 2018年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBEmptyView : UIView

- (void)setImageView:(UIImage *)image isShow:(BOOL)show;

- (void)setTitltString:(NSMutableAttributedString *)attrString isShow:(BOOL)show;

- (void)setDetailString:(NSMutableAttributedString *)attrString isShow:(BOOL)show;

- (void)setButonTitle:(NSMutableAttributedString *)titleAttrString forstate:(UIControlState)state isShow:(BOOL)show;

@end
