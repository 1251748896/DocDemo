//
//  BaseTableViewController.h
//  Demos
//
//  Created by 姜波 on 2020/12/17.
//  Copyright © 2020 姜波. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * _Nullable identifier = @"reuseIdentifier";
NS_ASSUME_NONNULL_BEGIN

@interface BaseTableViewController : UITableViewController
@property(nonatomic, assign) int page;
@property(nonatomic, assign) int pageSize;
@property(nonatomic, strong) NSMutableArray *array;
- (void)onRefresh;
- (void)fetchData;
- (void)successCallback:(NSArray *)data;
- (void)failureCallback;
@end

NS_ASSUME_NONNULL_END
