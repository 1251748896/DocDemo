//
//  ExcelViewController.m
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "ExcelViewController.h"

@interface ExcelViewController ()

@end

@implementation ExcelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _curArray = [NSMutableArray arrayWithArray:self.array];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    _tf = [[UITextField alloc] init];
    _tf.backgroundColor = [UIColor lightGrayColor];
    _tf.frame = CGRectMake(10, 10, 200, 44);
    [self.view addSubview:_tf];
    
    CGFloat btnW = 60;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(screenWidth - 10 - btnW, 10, btnW, 44);
    button.backgroundColor = [UIColor redColor];
    //    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [self.view addSubview:button];
    
    [button addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect frame = CGRectMake(0, 44, screenWidth, screenHeight - 44);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)search {
    _curArray = [NSMutableArray arrayWithArray:_array];
    int renshu_nei = [_tf.text intValue];
    NSLog(@"开始计算");
    for (NSString *str in _array) {
        NSArray *arr = [str componentsSeparatedByString:@"---"];
        int num = [[arr lastObject] intValue]; // 报名人数
        if (num >= renshu_nei) {
            [_curArray removeObject:str];
        }
    }
    for (NSString *obj in _curArray) {
        NSLog(@"%ld.----%@",[_curArray indexOfObject:obj],obj);
    }
    NSLog(@"计算完毕");
    NSLog(@"当前条件，共有%ld个岗位可选择",_curArray.count);
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 400;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _curArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    ExcelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ExcelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *dataStr = _curArray[indexPath.row];
    if (_allShow) {
        cell.label.text = [NSString stringWithFormat:@"%ld.----\n%@",indexPath.row,dataStr];
        
    } else {
        NSArray *arr = [dataStr componentsSeparatedByString:_sep];
        NSString *dw = @"";
        NSString *gw = @"";
        NSString *bm = @"";
        NSString *rs = @"";
        for (NSString *str in arr) {
            if (str.length > 0) {
                if (dw.length == 0) { dw = str; continue; }
                if (gw.length == 0) { gw = str; continue; }
                if (bm.length == 0) { bm = str; continue; }
                if (rs.length == 0) { rs = str; continue; }
            }
        }
        cell.danwei.text = dw;
        cell.gangwei.text = gw;
        cell.bianma.text = bm;
        cell.renshu.text = rs;
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
