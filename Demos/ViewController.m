//
//  ViewController.m
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "ViewController.h"
#import "ExcelViewController.h"
#import "FromData.h"
#import "ExcelGroupViewController.h"
#import "FeedBackListController.h"
#import "Reachability.h"
#import "Http.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];

    [self makeKaoShi];

}

- (void)tableViewPage {
    FeedBackListController *vc = [[FeedBackListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)makeKaoShi {
    _array = [NSMutableArray arrayWithCapacity:10];
    NSArray *keys = [FromData getListSource];
    [_array addObjectsFromArray:keys];
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    CGRect frame = CGRectMake(0, 20, screenWidth, screenHeight - 44);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *dataStr = _array[indexPath.row];
    cell.textLabel.text = dataStr;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ExcelViewController *vc = [[ExcelViewController alloc] init];
        NSArray *arr = [FromData getGoodData:NO];
        vc.array = arr.mutableCopy;
        vc.allShow = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

//    if (indexPath.row == 1) {
//        ExcelGroupViewController *vc = [[ExcelGroupViewController alloc] init];
//        NSMutableArray *arr = [FromData groupArray];
//        vc.array = arr;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
}

@end
