//
//  FromData.h
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FromData : NSObject

+ (NSString *)getMyGroupTag;
+ (NSString *)getMyAreaTag;
+ (NSMutableArray *)getGoodData; //
+ (NSMutableArray *)groupArray;
+ (NSArray *)getListSource; // 目录页 列表数据
@end

NS_ASSUME_NONNULL_END
