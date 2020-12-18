//
//  FeedBackListController.m
//  Demos
//
//  Created by 姜波 on 2020/12/18.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "FeedBackListController.h"
#import "CusTableViewCell.h"
#import "Http.h"
@interface FeedBackListController ()

@end

@implementation FeedBackListController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[CusTableViewCell class] forCellReuseIdentifier:identifier];
}

- (void)fetchData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *p = @{
        @"condition_StartTime":@"2020-09-18",
        @"condition_EndTime":@"",
        @"condition_OperatorName":@"2020-12-18",
        @"skipCount":@(self.page),
        @"maxResultCount":@(self.pageSize),
    };
    NSLog(@"self.page = %d",self.page);
    [Http get:p url:@"/api/services/Auth/FeedBack/GetList" callback:^(id _Nonnull data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            if (data[@"result"] && data[@"result"][@"items"]) {
                [weakSelf successCallback:data[@"result"][@"items"]];
            } else {
                NSLog(@"数据错误=%@",data);
            }
            
        } else {
            [weakSelf failureCallback];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setInfo:self.array[indexPath.row]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
