//
//  ViewController.h
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *array;


@end

