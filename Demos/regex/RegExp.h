//
//  RegExp.h
//  Demos
//
//  Created by HaoHuoBan on 2020/6/18.
//  Copyright © 2020 姜波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegExp : NSObject
+ (BOOL) validatePassword:(NSString *)passWord;
+ (BOOL) validateNickname:(NSString *)nickname;
@end

NS_ASSUME_NONNULL_END
