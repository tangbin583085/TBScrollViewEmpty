//
//  TBEmptyView.m
//  TBScrollViewEmpty
//
//  Created by hanchuangkeji on 2018/1/18.
//  Copyright © 2018年 hanchuangkeji. All rights reserved.
//

#import "TBEmptyView.h"

#define imageTopName @"data_empty"

#define titleString @"暂时无数据"

#define detailString @"暂时找不到任何与此相关的数据哦，请稍后再试吧~"

#define titleForBtn @"重试"

#define padding 20 // 边距

#define titleColor [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1.0]

#define detailColor [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1.0]

#define btnTitleColor [UIColor colorWithRed:93 / 255.0 green:109 / 255.0 blue:147 / 255.0 alpha:1.0]

#define titleFont [UIFont systemFontOfSize:14.0]

#define detailFont [UIFont systemFontOfSize:12.0]

@interface TBEmptyView()

@property (nonatomic, weak)UIImageView *imageViewTop; // 图片

@property (nonatomic, weak)UILabel *titleLB; // 标题

@property (nonatomic, weak)UILabel *detailLB; // 详情

@property (nonatomic, weak)UIButton *button; // 按钮

@property (nonatomic, assign)CGFloat totalHeight;

@end

@implementation TBEmptyView

- (void)setTotalHeight:(CGFloat)totalHeight {
    _totalHeight = totalHeight;
    CGRect frameTemp = self.frame;
    frameTemp.size.height = totalHeight;
    self.frame = frameTemp;
}

- (UIImageView *)imageViewTop {
    if (_imageViewTop == nil) {
        UIImageView *imageViewTop = [[UIImageView alloc] init];
        [self addSubview:imageViewTop];
        _imageViewTop = imageViewTop;
    }
    return _imageViewTop;
}

- (UILabel *)titleLB {
    if (_titleLB == nil) {
        UILabel *titleLB = [[UILabel alloc] init];
        titleLB.numberOfLines = 0;
        titleLB.textAlignment = NSTextAlignmentCenter;
        titleLB.font = titleFont;
        titleLB.textColor = titleColor;
        [self addSubview:titleLB];
        _titleLB = titleLB;
    }
    return _titleLB;
}

- (UILabel *)detailLB {
    if (_detailLB == nil) {
        UILabel *detailLB = [[UILabel alloc] init];
        detailLB.numberOfLines = 0;
        detailLB.textAlignment = NSTextAlignmentCenter;
        detailLB.font = detailFont;
        detailLB.textColor = detailColor;
        [self addSubview:detailLB];
        _detailLB = detailLB;
    }
    return _detailLB;
}

- (UIButton *)button {
    if (_button == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = titleFont;
        [button setTitleColor:btnTitleColor forState:UIControlStateNormal];
        [self addSubview:button];
        _button = button;
    }
    return _button;
}


- (void)setImageView:(UIImage *)image isShow:(BOOL)show {
    if (!show) return;
    
    self.imageViewTop.image = image? image : [UIImage imageNamed:imageTopName];
    CGSize size = image.size;
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    CGFloat y = 0;
    CGRect frame = CGRectMake(x, y, size.width, size.height);
    self.imageViewTop.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
}

- (void)setTitltString:(NSMutableAttributedString *)attrString isShow:(BOOL)show {
    if (!show) return;
    
    self.titleLB.attributedText = attrString? attrString : [[NSMutableAttributedString alloc] initWithString:titleString];
    NSRange range = NSMakeRange(0, attrString.string.length);
    NSDictionary *dic = [attrString attributesAtIndex:0 effectiveRange:&range];
    // 计算文字的高度
    CGFloat maxWidth = CGRectGetWidth(self.frame) - 2 * padding;
    CGFloat stringHeight = [attrString.string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 0.5;
    
    CGRect frame = CGRectMake(padding, self.totalHeight + padding, maxWidth, stringHeight);
    self.titleLB.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
}

- (void)setDetailString:(NSMutableAttributedString *)attrString isShow:(BOOL)show {
    if (!show) return;
    
    self.detailLB.attributedText = attrString? attrString : [[NSMutableAttributedString alloc] initWithString:detailString];
    NSRange range = NSMakeRange(0, attrString.string.length);
    NSDictionary *dic = [attrString attributesAtIndex:0 effectiveRange:&range];
    // 计算文字的高度
    CGFloat maxWidth = CGRectGetWidth(self.frame) - 2 * padding;
    CGFloat stringHeight = [attrString.string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 0.5;
    
    CGRect frame = CGRectMake(padding, self.totalHeight + padding, maxWidth, stringHeight);
    self.detailLB.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
    
}

- (void)setButonTitle:(NSMutableAttributedString *)titleAttrString forstate:(UIControlState)state isShow:(BOOL)show {
    
    if (!show) return;
    
    NSMutableAttributedString *attributedTextTemp = titleAttrString? titleAttrString : [[NSMutableAttributedString alloc] initWithString:detailString];
    
    [self.button setAttributedTitle:attributedTextTemp forState:state];
    CGFloat maxWidth = CGRectGetWidth(self.frame) - 2 * padding;
    CGRect frame = CGRectMake(padding, self.totalHeight + padding, maxWidth, self.button.titleLabel.font.pointSize);
    self.button.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
}

@end
