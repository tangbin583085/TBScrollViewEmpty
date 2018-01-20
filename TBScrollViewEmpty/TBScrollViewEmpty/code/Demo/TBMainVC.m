
//
//  TBPushVC.m
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBMainVC.h"
#import "TBDemo0.h"
#import "TBDemo1.h"
#import "TBDemo2.h"
#import "TBDemo3.h"
#import "TBDemo4.h"

@interface TBMainVC ()

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation TBMainVC

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@"默认样式"];
        [_dataSource addObject:@"网络异常样式"];
        [_dataSource addObject:@"代理自定义样式1"];
        [_dataSource addObject:@"自定义样式"];
        [_dataSource addObject:@"CollectionView样式"];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TBScrollViewEmpty";
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 兼容iOS11 表格
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    self.tableView.tableFooterView = [[UIView alloc] init];
}


#pragma mark <UITablViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self.navigationController pushViewController:[[TBDemo0 alloc] init] animated:YES];
    }else if(indexPath.row == 1) {
        [self.navigationController pushViewController:[[TBDemo1 alloc] init] animated:YES];
    }else if(indexPath.row == 2) {
        [self.navigationController pushViewController:[[TBDemo2 alloc] init] animated:YES];
    }else if(indexPath.row == 3) {
        [self.navigationController pushViewController:[[TBDemo3 alloc] init] animated:YES];
    }else if(indexPath.row == 4) {
        [self.navigationController pushViewController:[[TBDemo4 alloc] init] animated:YES];
    }
}

@end
