//
//  BaseModel.h
//  TongYuan
//
//  Created by 姜波 on 2017/12/6.
//  Copyright © 2017年 姜波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
- (void)JSON:(NSDictionary *)dic;
- (instancetype)initWithDictionary:(NSDictionary *)d;
@end
