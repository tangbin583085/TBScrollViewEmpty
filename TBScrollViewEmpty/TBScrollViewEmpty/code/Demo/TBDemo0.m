//
//  TBTableViewController.m
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBDemo0.h"
#import "MJRefresh.h"
#import "TBScrollViewEmpty.h"

@interface TBDemo0 ()

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic, assign)BOOL isFirstTimeIn;

@end

@implementation TBDemo0

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Demo0";
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
    
    [self.tableView.mj_header beginRefreshing];
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
