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
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
//    [self deepCopyObject:@[]];

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


- (id)deepCopyObject:(id)obj {
    
    NSMutableDictionary *pp = @{
        @"hello":@"你好",
        @"data": @{@"name": @"小王",
                   @"wf": @{@"name":@"小丽"}.mutableCopy
                   }.mutableCopy,
        @"list": @[@"222",@"333",@[@"444"].mutableCopy].mutableCopy
        }.mutableCopy;
    NSDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:pp copyItems:YES]; // mutableCopy
//    NSMutableDictionary *dict1 = [dict mutableCopy];

    
    NSMutableDictionary *xx = pp[@"data"][@"wf"];
    [xx setValue:@"小花" forKey:@"name"];
    
    NSLog(@"pp = %@",pp[@"data"][@"wf"][@"name"]);
    NSLog(@"dict1 = %@",dict1[@"data"][@"wf"][@"name"]); // 显示“我被干掉了” --------修改了“data”字段
    

//    NSLog(@"dict1_data = %d",[dict1[@"data"] isKindOfClass:[NSMutableDictionary class]]);
//    NSLog(@"dict1_list = %d",[dict1[@"list"] isKindOfClass:[NSMutableArray class]]);
//    NSLog(@"dict1_list[2] = %d",[dict1[@"list"][2] isKindOfClass:[NSMutableArray class]]);
//    NSLog(@"-----------------------");
//
//    NSLog(@"dict1 = %d",[dict1 isKindOfClass:[NSMutableDictionary class]]);
//    NSLog(@"-----------------------");
////    [dict1[@"data"][@"wf"] setValue:@"姜波" forKey:@"name"];
//
//    NSLog(@"dict1_data_wf = %d",[dict1[@"data"][@"wf"] isKindOfClass:[NSMutableDictionary class]]);
    
    
//    NSLog(@"*****************************************");
//    NSLog(@"*****************************************");
//
//    // 查看地址
//    NSLog(@"dict = %p",dict);
//    NSLog(@"dict1 = %p",dict1);
//    NSLog(@"dict2 = %p",dict2);
//
//    NSLog(@"dict-hello-地址 = %p",dict[@"hello"]);
//    NSLog(@"dict1-hello-地址 = %p",dict1[@"hello"]);
//    NSLog(@"dict2-hello-地址 = %p",dict2[@"hello"]);
//
//    NSLog(@"dict-data-地址 = %p",dict[@"data"]);
//    NSLog(@"dict1-data-地址 = %p",dict1[@"data"]);
//    NSLog(@"dict2-data-地址 = %p",dict2[@"data"]);
    
    // dict = dict2 ，且和dict1不相同。
    
    
    // 修改第二层级的“data”
//    NSMutableDictionary *xx = dict1[@"data"];
//    [xx setValue:@"小明" forKey:@"name"];
//    [xx setValue:@"hello" forKey:@"name"];
//    NSLog(@"dict = %@",dict[@"data"][@"name"]); // 显示"小明"--------原dict没有改变
//    NSLog(@"dict1 = %@",dict1[@"data"][@"name"]); // 显示"小明" -----更深层的数据是浅复制
    
//    NSLog(@"*************************************************************************************************************************************************");
    
//        NSArray *arr = @[@"data", @{@"name": @"小王"}.mutableCopy];
//        NSMutableArray *arr1 = [arr mutableCopy]; // mutableCopy
//        NSLog(@"arr = %@",arr[1][@"name"]); // 显示“小王”
//
//        NSMutableDictionary *xx = arr1[1];
//        [xx setValue:@"小明" forKey:@"name"]; // 设置name = 小明
//        NSLog(@"dict = %@",arr[1][@"name"]);
//        NSLog(@"dict1 = %@",arr[1][@"name"]);
//
//
    
//    NSMutableArray *array1 = [NSMutableArray arrayWithArray:@[dict]];
    
    
    
    if (obj == nil) { return nil; }
    
    id deepObj;
    for (id o in obj) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            
        } else if ([obj isKindOfClass:[NSArray class]]) {
            
        } else if ([obj isKindOfClass:[NSString class]]) {
            
        } else if ([obj isKindOfClass:[NSString class]]) {
            
        } else if ([obj isKindOfClass:[NSString class]]) {
            
        } else if ([obj isKindOfClass:[NSString class]]) {
            
        }
    }
    
    return deepObj;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == 0) {
        ExcelViewController *vc = [[ExcelViewController alloc] init];
        NSMutableArray *arr = [FromData getGoodData:YES];
        vc.array = arr;
        vc.allShow = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 1) {
        ExcelGroupViewController *vc = [[ExcelGroupViewController alloc] init];
        NSMutableArray *arr = [FromData groupArray];
        vc.array = arr;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

@end
