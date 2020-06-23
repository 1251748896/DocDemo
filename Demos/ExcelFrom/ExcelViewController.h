//
//  ExcelViewController.h
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "BaseViewController.h"
#import "ExcelCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExcelViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSMutableArray *array;
@property (nonatomic) NSMutableArray *curArray;
@property (nonatomic) id sep;
@property (nonatomic, assign) BOOL allShow;
@property (nonatomic) UITextField *tf;

@end

NS_ASSUME_NONNULL_END
