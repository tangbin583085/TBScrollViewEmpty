//
//  UIScrollView+TBEmpty.h
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TBEmptyDelegate<NSObject>

@optional
- (UIView *)tb_emptyView;
- (UIImage *)tb_emptyImage;
- (NSString *)tb_emptyString;
- (UIEdgeInsets)tb_emptyViewInset;


@end

@interface UIScrollView (TBEmpty)

@property (nonatomic, assign)BOOL tb_showEmptyView;

@property (nonatomic, assign)id<TBEmptyDelegate> tb_EmptyDelegate;

@end

