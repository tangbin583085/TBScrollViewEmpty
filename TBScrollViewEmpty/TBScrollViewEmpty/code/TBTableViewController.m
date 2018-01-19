//
//  TBTableViewController.m
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBTableViewController.h"
#import "MJRefresh.h"
#import "UIScrollView+TBEmpty.h"
#import "TBNetworkReachability.h"

@interface TBTableViewController ()<TBSrollViewEmptyDelegate>

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic) TBNetworkReachability *internetReachability;

@end

@implementation TBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.internetReachability = [TBNetworkReachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    [self networkdStatus:self.internetReachability];
    
    self.dataSource = [NSMutableArray array];
    
    MJRefreshHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = mj_header;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 兼容iOS11 表格
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView.mj_header beginRefreshing];
    
    // 设置代理
    self.tableView.tb_EmptyDelegate = self;
}

#pragma mark <TBSrollViewEmptyDelegate>
- (BOOL)tb_showEmptyView {
    return NO;
}

#pragma mark <网络状态>
- (TBNetworkStatus)networkdStatus:(TBNetworkReachability *)reachability {
    TBNetworkStatus netStatus = [reachability currentReachabilityStatus];
    switch (netStatus)
    {
        case TBNetworkStatusNotReachable:
            NSLog(@"无网络");
            break;
        case TBNetworkStatusReachableViaWWAN:        {
            NSLog(@"Reachable WWAN");
            break;
        }
        case TBNetworkStatusReachableViaWiFi:        {
            NSLog(@"WIFI");
            break;
        }
    }
    return netStatus;
}


#pragma mark <TBSrollViewEmptyDelegate>
//- (UIView *)tb_emptyView {
//    UIView *myView = [[UIView alloc] init];
//    myView.backgroundColor = [UIColor orangeColor];
////    myView.frame = CGRectMake(100, 100, 100, 100);
//    [self.view addSubview:myView];
//    return myView;
//}

//- (UIEdgeInsets)tb_emptyViewInset {
//    return UIEdgeInsetsMake(200, 0, 50, 0);
//}

//- (UIImage *)tb_emptyImage {
//    return [UIImage imageNamed:@"otherImage"];
//}


//- (NSString *)tb_emptyString {
//    return @"查询不到你所需的数据";
//}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
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
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];

    });
}



@end
