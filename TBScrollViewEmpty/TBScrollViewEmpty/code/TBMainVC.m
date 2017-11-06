
//
//  TBPushVC.m
//  TBCoreData8
//
//  Created by hanchuangkeji on 2017/11/3.
//  Copyright © 2017年 hanchuangkeji. All rights reserved.
//

#import "TBMainVC.h"
#import "TBTableViewController.h"
#import "TBCollectionViewController.h"

@interface TBMainVC ()

@end

@implementation TBMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
}


#pragma mark <UITablViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"UITableView 空数据提示";
    }else if(indexPath.row == 1) {
        cell.textLabel.text = @"UICollectionView 空数据提示";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self presentViewController:[[TBTableViewController alloc] init] animated:YES completion:nil];
    }else if(indexPath.row == 1) {
        [self presentViewController:[[TBCollectionViewController alloc] init] animated:YES completion:nil];
    }
}

@end
