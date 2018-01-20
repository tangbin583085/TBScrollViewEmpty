//
//  TBCollectionViewController.m
//  TBScrollViewEmpty
//
//  Created by hanchuangkeji on 2017/11/6.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBDemo4.h"
#import "MJRefresh.h"
#import "TBScrollViewEmpty.h"

@interface TBDemo4 ()<UICollectionViewDelegate, UICollectionViewDataSource, TBSrollViewEmptyDelegate>
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, weak)UICollectionView *collectionView;
@property (nonatomic, assign)BOOL isFirstTimeIn;
@end

@implementation TBDemo4

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstTimeIn = YES;
    self.title = @"Collection";
    
    self.dataSource = [NSMutableArray array];
    
    UICollectionView * collectionView = [self createCollectionView];
    
    // 设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.tb_EmptyDelegate = self;
    // 兼容iOS11 表格
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark <TBSrollViewEmptyDelegate>
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {
    [self loadNewData];
}

- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"点我重试" attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    return attrString;
}


#pragma mark <UICollectionView>
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

//当cell高亮时返回是否高亮
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Highlight)高亮下的颜色
    [cell setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:1.0]];
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //设置(Nomal)正常状态下的颜色
    [cell setBackgroundColor:[UIColor redColor]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)loadNewData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (!self.isFirstTimeIn) {
            [self.dataSource removeAllObjects];
            
            // 随机
            if (arc4random() % 2 == 0) {
                for (int i = 0; i < 20; i++) {
                    [self.dataSource addObject:[NSString stringWithFormat:@"我是第%d个", i]];
                }
            }
            
        } else {
            self.isFirstTimeIn = NO;
        }
        
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView reloadData];
        
    });
}


@end
