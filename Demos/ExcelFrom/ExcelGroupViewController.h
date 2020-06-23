//
//  ExcelGroupViewController.h
//  Demos
//
//  Created by HaoHuoBan on 2020/6/18.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "BaseViewController.h"
#import "ExcelCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface ExcelGroupViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_curArray;
}
@property (nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *array;
@property (nonatomic) UITextField *tf;

@end

NS_ASSUME_NONNULL_END
