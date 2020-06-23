//
//  ExcelGroupViewController.m
//  Demos
//
//  Created by HaoHuoBan on 2020/6/18.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "ExcelGroupViewController.h"
#import "FromData.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ExcelGroupViewController ()

@end

@implementation ExcelGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _curArray = _array;
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGFloat headerH = 35.0;
    CGFloat maiginTop = 10.0;
    
    UIView *leftView = [[UIView alloc] init];
    leftView.bounds = CGRectMake(0, 0, 10, headerH);
    _tf = [[UITextField alloc] init];
    _tf.backgroundColor = UIColorFromRGB(0xf5f5f5);
    _tf.layer.cornerRadius = 3.0;
    _tf.leftView = leftView;
    _tf.leftViewMode = UITextFieldViewModeAlways;
    _tf.placeholder = @"请输入最大报名人数查询";
    _tf.layer.masksToBounds = YES;
    _tf.frame = CGRectMake(10, maiginTop, 300, headerH);
    [self.view addSubview:_tf];
    
    CGFloat btnW = 60;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenWidth - 10 - btnW, maiginTop, btnW, headerH);
    button.backgroundColor = UIColorFromRGB(0xe7e7e7);
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 3.0;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat tableViewY = maiginTop + headerH + maiginTop;
    
    CGRect frame = CGRectMake(0, tableViewY, screenWidth, screenHeight - tableViewY);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


- (void)search {
    _curArray = [[NSMutableArray alloc] initWithArray:_array copyItems:YES];
    int renshu_nei = [_tf.text intValue];
    NSLog(@"开始计算");
    NSString *sep = [FromData getMyAreaTag];
    for (int i=0; i<[_array count]; i++) {
        NSDictionary *dict = _array[i];
        NSMutableArray *areaArr = dict[@"data"];
        for (NSString *str in areaArr) {
            NSArray *arr = [str componentsSeparatedByString:sep];
            int num = [[arr lastObject] intValue]; // 报名人数
            if (num >= renshu_nei) {
                NSDictionary *realDict = [_curArray objectAtIndex:i];
                NSMutableArray *cur =  realDict[@"data"];
                //                [cur removeObject:str];
            }
        }
    }
    NSLog(@"数量 <= %d的职位如下：",renshu_nei);
    for (NSDictionary *obj in _curArray) {
        NSLog(@"%ld.----%@--共有：%ld个职位可选",[_curArray indexOfObject:obj],obj[@"title"],[(NSMutableArray *)obj[@"data"] count]);
        NSArray *arr = obj[@"data"];
        for (NSString *info in arr) {
            NSLog(@"(%ld).-----%@",[arr indexOfObject:info],info);
        }
    }
    NSLog(@"计算完毕");
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _curArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = _curArray[section][@"data"];
    return arr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSDictionary *dict = _curArray[section];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xe7e7e7);
    view.frame = CGRectMake(0, 0, 380, 44);
    UILabel *label = [[UILabel alloc] init];
    label.frame = view.frame;
    label.text = dict[@"title"];
    label.textColor = [UIColor blackColor];
    [view addSubview:label];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    ExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ExcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dict = _curArray[indexPath.section];
    NSString *info = dict[@"data"][indexPath.row] ;
    cell.label.text = [NSString stringWithFormat:@"%ld.----\n%@",indexPath.row,info];
    return cell;
}


@end
