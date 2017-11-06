//
//  TBCollectionViewController.m
//  TBScrollViewEmpty
//
//  Created by hanchuangkeji on 2017/11/6.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBCollectionViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+TBEmpty.h"

@interface TBCollectionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, TBEmptyDelegate>
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, weak)UICollectionView *collectionView;
@end

@implementation TBCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    UICollectionView * collectionView = [self createCollectionView];
    
    // 设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.tb_showEmptyView = YES;
    collectionView.tb_EmptyDelegate = self;
    
    // 兼容iOS11 表格
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.collectionView.mj_header beginRefreshing];
}

- (UICollectionView *)createCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.frame.size.width, 100);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.view addSubview:collectionView];
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    MJRefreshHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.collectionView.mj_header = mj_header;
    return collectionView;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [[cell.contentView viewWithTag:1] removeFromSuperview];
    UILabel *label = [[UILabel alloc] init];
    label.text = self.dataSource[indexPath.row];
    [label sizeToFit];
    label.textColor = [UIColor whiteColor];
    label.tag = 1;
    [cell.contentView addSubview:label];
    
    CGFloat colorRGB1 = arc4random() % 11 * 0.1;
    CGFloat colorRGB2 = arc4random() % 11 * 0.1;
    CGFloat colorRGB3 = arc4random() % 11 * 0.1;
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:colorRGB1 green:colorRGB2 blue:colorRGB3 alpha:1.0];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadNewData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        static BOOL emptyTemp = NO;
        [self.dataSource removeAllObjects];
        if (emptyTemp) {
            for (int i = 0; i < 20; i++) {
                [self.dataSource addObject:[NSString stringWithFormat:@"我是第%d个", i]];
            }
            emptyTemp = NO;
        }else {
            emptyTemp = YES;
        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        
    });
}


@end
