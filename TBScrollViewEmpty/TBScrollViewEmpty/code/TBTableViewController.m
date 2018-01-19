//
//  TBTableViewController.m
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBTableViewController.h"
#import "MJRefresh.h"
#import "TBScrollViewEmpty.h"
#import "TBCollectionViewController.h"

@interface TBTableViewController ()<TBSrollViewEmptyDelegate>

@property (nonatomic, strong)NSMutableArray *dataSource;

@property (nonatomic) TBNetworkReachability *internetReachability;

@end

@implementation TBTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TableView";
    
    self.dataSource = [NSMutableArray array];
    
    MJRefreshHeader *mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = mj_header;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // 兼容iOS11 表格
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView.mj_header beginRefreshing];
    
    // 设置代理
//    self.tableView.tb_EmptyDelegate = self;
}

#pragma mark <TBSrollViewEmptyDelegate>
//- (BOOL)tb_showEmptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//    return YES;
//}
//
//- (UIImage *)tb_emptyImage:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//    if (status == TBNetworkStatusNotReachable) {
//        return [UIImage imageNamed:@"network"];
//    } else if (status == TBNetworkStatusReachableViaWWAN) {
//        return [UIImage imageNamed:@"car"];
//    } else {
//        return [UIImage imageNamed:@"goods"];
//    }
//}
//
//- (NSAttributedString *)tb_emptyTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//
//    if (status == TBNetworkStatusNotReachable) {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"网路异常"];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attrString.string.length)];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0] range:NSMakeRange(0, attrString.string.length)];
//        return attrString;
//    } else if (status == TBNetworkStatusReachableViaWWAN) {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"4G网路"];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:NSMakeRange(0, attrString.string.length)];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attrString.string.length)];
//        return attrString;
//    } else {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"WIFI网络"];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, attrString.string.length)];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attrString.string.length)];
//        return attrString;
//    }
//}
//
//// 详情
//- (NSAttributedString *)tb_emptyDetial:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//
//    if (status == TBNetworkStatusNotReachable) {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"网路异常123456789网路异常123456789网路异常123456789网路异常123456789网路异常123456789网路异常123456789网路异常123456789网路异常123456789网路异常123456789"];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attrString.string.length)];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0] range:NSMakeRange(0, attrString.string.length)];
//        return attrString;
//    } else if (status == TBNetworkStatusReachableViaWWAN) {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"4G网路123456789 4G网路123456789 4G网路123456789 4G网路123456789 4G网路123456789 4G网路123456789"];
//        return attrString;
//    } else {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"WIFI网络123456789WIFI网络123456789WIFI网络123456789WIFI网络123456789WIFI网络123456789WIFI网络123456789WIFI网络123456789WIFI网络123456789WIFI网络123456789"];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, attrString.string.length)];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, attrString.string.length)];
//        return attrString;
//    }
//}
//
//- (NSAttributedString *)tb_emptyButtonTitle:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//
//    if (status == TBNetworkStatusNotReachable) {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"网路异常123"];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, attrString.string.length)];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30.0] range:NSMakeRange(0, attrString.string.length)];
//        return attrString;
//    } else if (status == TBNetworkStatusReachableViaWWAN) {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"4G网路123"];
//        return attrString;
//    } else {
//        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@"WIFI网络123"];
//        [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(0, attrString.string.length)];
//        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:NSMakeRange(0, attrString.string.length)];
//        return attrString;
//    }
//}
//
- (void)tb_emptyButtonClick:(UIButton *)btn network:(TBNetworkStatus)status {

    NSLog(@"%s  %@", __func__, btn);
    [self loadNewData];
}
//
//
//- (CGPoint)tb_emptyViewOffset:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//    return CGPointMake(0, 0);
//}
//
//- (UIView *)tb_emptyView:(UIScrollView *)scrollView network:(TBNetworkStatus)status {
//    UIView *myView = [[UIView alloc] init];
//    myView.backgroundColor = [UIColor orangeColor];
//    myView.frame = CGRectMake(100, 100, 100, 100);
//    return myView;
//}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TBCollectionViewController *VC = [[TBCollectionViewController alloc] init];
    [self.navigationController pushViewController:VC animated:YES];
//    [self presentViewController:VC animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}


- (void)loadNewData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        BOOL emptyTemp = arc4random() % 2 == 0;
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
