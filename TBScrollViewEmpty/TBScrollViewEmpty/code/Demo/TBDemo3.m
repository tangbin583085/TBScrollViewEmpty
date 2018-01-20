//
//  TBDemo1.m
//  TBScrollViewEmpty
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBDemo3.h"
#import "MJRefresh.h"
#import "TBScrollViewEmpty.h"

@interface TBDemo3 ()<TBSrollViewEmptyDelegate>

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign)BOOL isFirstTimeIn;

@end

@implementation TBDemo3

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo1";
    self.isFirstTimeIn = YES;
    self.dataSource = [NSMutableArray array];
    
    MJRefreshHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = mj_header;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // 兼容iOS11 表格
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 设置代理
    self.tableView.tb_EmptyDelegate = self;
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - TBSrollViewEmptyDelegate
// 完全自定义
- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width,  210)];
    
    // imagetView top
    UIImageView *imageViewTop = [[UIImageView alloc] init];
    imageViewTop.image = [UIImage imageNamed:@"goods"];
    imageViewTop.frame = CGRectMake(0.5 * (emptyView.frame.size.width - imageViewTop.image.size.width), 0, imageViewTop.image.size.width, imageViewTop.image.size.height);
    [emptyView addSubview:imageViewTop];
    
    // 设置title
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"这是自定义的标题";
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.frame = CGRectMake(0, CGRectGetMaxY(imageViewTop.frame) + 20, emptyView.frame.size.width, 15);
    [emptyView addSubview:titleLabel];
    
    // 设置title
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textAlignment = NSTextAlignmentCenter;
    detailLabel.textColor = [UIColor grayColor];
    detailLabel.text = @"这是详情的描述~";
    detailLabel.font = [UIFont systemFontOfSize:12.0];
    detailLabel.frame = CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 20, emptyView.frame.size.width, 15);
    [emptyView addSubview:detailLabel];
    return emptyView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - 加载数据
- (void)loadNewData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 首次进来默认空
        if (self.isFirstTimeIn) {
            self.isFirstTimeIn = NO;
        } else {
            
            [self.dataSource removeAllObjects];
            for (int i = 0; i < 20; i++) {
                [self.dataSource addObject:[NSString stringWithFormat:@"我是第%d个", i]];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    });
}



@end



