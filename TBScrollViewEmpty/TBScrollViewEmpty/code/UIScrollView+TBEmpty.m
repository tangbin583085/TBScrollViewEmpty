//
//  UIScrollView+TBEmpty.m
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "UIScrollView+TBEmpty.h"
#import <objc/runtime.h>

@implementation NSObject (TBEmpty)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)exchangeClassMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getClassMethod(self, method1), class_getClassMethod(self, method2));
}

@end


@implementation UIScrollView (TBEmpty)

static const char TBShowEmptyViewStoreKey = '\0'; // 自定义显示提示View
static const char TBSystemReload = '\0'; // 系统reloadData
static const char TBEmptyView = '\0'; // 空View容器
static const char TBEmptyDelegateKey = '\0'; // 自定义属性的代理

// 代理
- (void)setTb_EmptyDelegate:(id<TBEmptyDelegate>)tb_EmptyDelegate {
    // 存储
    objc_setAssociatedObject(self, &TBEmptyDelegateKey,
                             tb_EmptyDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<TBEmptyDelegate>)tb_EmptyDelegate {
    return objc_getAssociatedObject(self, &TBEmptyDelegateKey);
}


- (void)setTb_showEmptyView:(BOOL)tb_showEmptyView {
    // 存储
    objc_setAssociatedObject(self, &TBShowEmptyViewStoreKey,
                             @(tb_showEmptyView), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)tb_showEmptyView {
    return objc_getAssociatedObject(self, &TBShowEmptyViewStoreKey);
}

- (void)createEmptyView {
    
    CGFloat viewWidth = self.frame.size.width;
    CGFloat viewHeight = self.frame.size.height;
    CGRect rect = CGRectMake(viewWidth * 0.25, 0.5 * (viewHeight - viewWidth * 0.5), viewWidth * 0.5, viewWidth * 0.5);
    UIView *emptyView = nil;
    
    // 获取代理的View
    if ([self.tb_EmptyDelegate respondsToSelector:@selector(tb_emptyView)]) {
        emptyView = [self.tb_EmptyDelegate tb_emptyView];
        
        // 没有设置frame
        if (CGRectIsEmpty(emptyView.frame) || CGRectIsEmpty(emptyView.frame)) {
            emptyView.frame = rect;
        }
        
    }else {// 系统默认的
        emptyView = [[UIView alloc] initWithFrame:rect];
        
        // 添加图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(rect.size.width * 0.2, 0, rect.size.width * 0.6 , rect.size.width * 0.6);
        imageView.clipsToBounds = YES;
        
        // 获取自定义的图片
        if ([self.tb_EmptyDelegate respondsToSelector:@selector(tb_emptyImage)]) {
            imageView.image = self.tb_EmptyDelegate.tb_emptyImage;
        }else {
            imageView.image = [UIImage imageNamed:@"data_empty"];
        }
        [emptyView addSubview:imageView];
        
        // 添加提示语句
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor lightGrayColor];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.font = [UIFont systemFontOfSize:14.0];
        tipLabel.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + 20, emptyView.frame.size.width, tipLabel.font.pointSize);
        [emptyView addSubview:tipLabel];
        
        // 设置提示文字
        if ([self.tb_EmptyDelegate respondsToSelector:@selector(tb_emptyString)]) {
            tipLabel.text = self.tb_EmptyDelegate.tb_emptyString;
        }else {
            tipLabel.text = @"暂时无数据";
        }
    }
    
    // 添加到父控件
    objc_setAssociatedObject(self, &TBEmptyView,
                             emptyView, OBJC_ASSOCIATION_ASSIGN);
    [self addSubview:emptyView];
    [self bringSubviewToFront:emptyView];
    
    // 设置偏移量
    if ([self.tb_EmptyDelegate respondsToSelector:@selector(tb_emptyViewInset)]) {
        UIEdgeInsets inset = [self.tb_EmptyDelegate tb_emptyViewInset];
        CGRect newRect = CGRectMake(emptyView.frame.origin.x - inset.left, emptyView.frame.origin.y - inset.top, emptyView.frame.size.width - inset.right, emptyView.frame.size.height - inset.bottom);
        emptyView.frame = newRect;
    }
    
}

- (void)addOrMoveEmptyView {
    
    // 存储首次运行reloadData, 系统表格LayoutSubViews
    if (!objc_getAssociatedObject(self, &TBSystemReload)) {
        // 存储
        objc_setAssociatedObject(self, &TBSystemReload,
                                 @(YES), OBJC_ASSOCIATION_ASSIGN);
        return;
    }
    
    if (![self tb_showEmptyView]) return;
    
    UIView *emptyView = objc_getAssociatedObject(self, &TBEmptyView);
    
    // 移除
    if (emptyView && [self tb_totalDataCount] > 0) {
        [emptyView removeFromSuperview];
        objc_setAssociatedObject(self, &TBEmptyView,
                                 nil, OBJC_ASSOCIATION_ASSIGN);
    }else if (!emptyView && [self tb_totalDataCount] <= 0){
        // 新建
        [self createEmptyView];
    }
}

#pragma mark - 获取Data数量
- (NSInteger)tb_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}


@end

@implementation UITableView (TBEmpty)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(tb_reloadData)];
}

- (void)tb_reloadData
{
    [self tb_reloadData];
    
    [self addOrMoveEmptyView];
}
@end

@implementation UICollectionView (TBEmpty)

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(reloadData) method2:@selector(tb_reloadData)];
}

- (void)tb_reloadData
{
    [self tb_reloadData];
    
    [self addOrMoveEmptyView];
}
@end
