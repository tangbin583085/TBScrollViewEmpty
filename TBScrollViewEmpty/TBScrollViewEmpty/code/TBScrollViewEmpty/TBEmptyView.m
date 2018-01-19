//
//  TBEmptyView.m
//  TBScrollViewEmpty
//
//  Created by hanchuangkeji on 2018/1/18.
//  Copyright © 2018年 hanchuangkeji. All rights reserved.
//

#import "TBEmptyView.h"

#define imageTopName @"star"

#define imageTopNetName @"network"

#define titleString @"暂时无数据"

#define titleNetString @"无法访问网络"

#define detailString @"暂时找不到任何与此相关的数据哦，请稍后再试吧~"

#define detailNetDetailString @"请检查网络设置，并允许本App访问网络数据"

#define titleForBtn @"重试"

#define padding 40 // 左边边距
#define paddingTop 20 // 上下边距

#define titleColor [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1.0]

#define detailColor [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1.0]

#define btnTitleColor [UIColor colorWithRed:53 / 255.0 green:126 / 255.0 blue:222 / 255.0 alpha:1.0]

#define titleFont [UIFont systemFontOfSize:14.0]

#define detailFont [UIFont systemFontOfSize:12.0]

#define btnTitleFont [UIFont systemFontOfSize:16.0]

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
    
    // 调整高度和Y
    CGRect frameTemp = self.frame;
    frameTemp.size.height = totalHeight;
    frameTemp.origin.y = (CGRectGetHeight(self.superview.frame) - totalHeight ) * 0.45;
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
        button.titleLabel.font = btnTitleFont;
        [button setTitle:titleForBtn forState:UIControlStateNormal];
        [button setTitleColor:btnTitleColor forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        _button = button;
    }
    return _button;
}

- (void)btnClickEvent:(UIButton *)btn {
    
    // 转圈圈
    if (self.imageViewTop.image) {
        self.imageViewTop.contentMode = UIViewContentModeCenter;
        self.imageViewTop.image = [UIImage imageNamed:@"loading_imgBlue"];
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
        animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
        animation.duration = 0.25;
        animation.cumulative = YES;
        animation.repeatCount = MAXFLOAT;
        [self.imageViewTop.layer addAnimation:animation forKey:@"transform"];
    }
    
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:btn];
    }
    NSLog(@"1111");
}

- (void)setImageView:(UIImage *)image network:(TBNetworkStatus)status isShow:(BOOL)show {
    if (!show) return;
    
    self.imageViewTop.image = image? image : status == TBNetworkStatusNotReachable? [UIImage imageNamed:imageTopNetName] : [UIImage imageNamed:imageTopName];
    CGSize size = self.imageViewTop.image.size;
    CGFloat x = (self.frame.size.width - size.width) * 0.5;
    CGFloat y = 0;
    CGRect frame = CGRectMake(x, y, size.width, size.height);
    self.imageViewTop.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
}

- (void)setTitltString:(NSAttributedString *)attrString network:(TBNetworkStatus)status isShow:(BOOL)show {
    if (!show) return;
    
    NSAttributedString *tempString = attrString? attrString : status == TBNetworkStatusNotReachable? [[NSMutableAttributedString alloc] initWithString:titleNetString attributes:@{NSFontAttributeName : titleFont}] : [[NSMutableAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName : titleFont}];
    self.titleLB.attributedText = tempString;
    NSRange range = NSMakeRange(0, tempString.string.length);
    NSDictionary *dic = [tempString attributesAtIndex:0 effectiveRange:&range];
    // 计算文字的高度
    CGFloat maxWidth = CGRectGetWidth(self.frame) - 2 * padding;
    CGFloat stringHeight = [tempString.string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 0.5;
    
    CGRect frame = CGRectMake(padding, self.totalHeight + paddingTop, maxWidth, stringHeight);
    self.titleLB.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
}

- (void)setDetailString:(NSAttributedString *)attrString network:(TBNetworkStatus)status isShow:(BOOL)show {
    if (!show) return;
    
    NSAttributedString *stringTemp = attrString? attrString : status == TBNetworkStatusNotReachable? [[NSMutableAttributedString alloc] initWithString:detailNetDetailString attributes:@{NSFontAttributeName : detailFont}] : [[NSMutableAttributedString alloc] initWithString:detailString attributes:@{NSFontAttributeName : detailFont}];
    
    self.detailLB.attributedText = stringTemp;
    NSRange range = NSMakeRange(0, stringTemp.string.length);
    NSDictionary *dic = [stringTemp attributesAtIndex:0 effectiveRange:&range];
    // 计算文字的高度
    CGFloat maxWidth = CGRectGetWidth(self.frame) - 2 * padding;
    CGFloat stringHeight = [stringTemp.string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size.height + 0.5;
    
    CGRect frame = CGRectMake(padding, self.totalHeight + paddingTop, maxWidth, stringHeight);
    self.detailLB.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
}

- (void)setButonTitle:(NSAttributedString *)titleAttrString network:(TBNetworkStatus)status isShow:(BOOL)show {
    
    if (!show) return;
    
    if (titleAttrString) {
        [self.button setAttributedTitle:titleAttrString forState:UIControlStateNormal];
    }
    
    CGFloat maxWidth = CGRectGetWidth(self.frame) - 4 * padding;
    CGRect frame = CGRectMake(padding * 2, self.totalHeight + paddingTop * 0.5, maxWidth, self.button.titleLabel.font.pointSize + padding);
    self.button.frame = frame;
    
    // 更新总高度
    self.totalHeight = CGRectGetMaxY(frame);
}

@end
