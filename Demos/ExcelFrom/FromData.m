//
//  FromData.m
//  Demos
//
//  Created by 姜波 on 2020/6/15.
//  Copyright © 2020 姜波. All rights reserved.
//

#import "FromData.h"
#import "RegExp.h"
static NSMutableArray *ICanArray;
static NSArray *payPeopleCountArray;
static NSMutableArray *goodData;
static id sepTag;

static NSString *groupTag = @"-group-";
static NSString *areaTag = @"--area--";

@implementation FromData


+ (NSString *)getMyAreaTag {
    return areaTag;
}

+ (NSString *)getMyGroupTag {
    return groupTag;
}

+ (id)getSepTag:(NSString *)str {

    if (sepTag) {
        return sepTag;
    }
    NSString *dataStr = str ;
    NSString *temp ;
    
    id _sep = @"";
    for(int i =0; i < [dataStr length]; i++)
    {
        temp = [dataStr substringWithRange:NSMakeRange(i, 1)];
        NSString *type = NSStringFromClass([temp class]);
        BOOL isNum = [RegExp validatePassword:temp];
        BOOL isChina = [RegExp validateNickname:temp];
        if ([type isEqualToString:@"NSTaggedPointerString"] && !isNum && !isChina && [temp intValue] == 0) {
            _sep = temp;
            break;
        }
    }
    sepTag = _sep;
    return _sep;
}

+ (NSArray *)getDataSource:(NSString *)fileName {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [content componentsSeparatedByString:@"\n"];
    return arr;
}

+ (BOOL)locationData {
    return YES;
}

+ (NSMutableArray *)groupArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:30];
    NSMutableArray *showArr = [self getGoodData];
    NSString *curKey = nil;
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:20];
    NSInteger len = [showArr count];
    for (int i=0; i<len; i++) {
        NSString *info = showArr[i];
        NSArray *gangwei_info = [info componentsSeparatedByString:groupTag];
        NSString *key = [[[gangwei_info lastObject] componentsSeparatedByString:areaTag] firstObject];
        if (curKey == nil) {
            curKey = key;
            [tempArr addObject:info];
        } else if ([curKey isEqualToString:key]) {
            [tempArr addObject:info];
        } else {
            [array addObject: @{@"title":curKey,@"data":tempArr}];
            curKey = key;
            tempArr = [NSMutableArray arrayWithCapacity:20];
            [tempArr addObject:info];
        }
        if (i + 1 == len) {
            [array addObject:@{@"title":curKey,@"data":tempArr}];
        }
    }
    return array;
}

+ (NSMutableArray *)binali:(NSArray *)can bianmaArr:(NSArray *)bianmaArr {
    NSMutableArray *resu = [NSMutableArray arrayWithCapacity:400];
    NSInteger index = 0;
    NSInteger total = can.count;
    for (NSString *info in can) {
       for (NSString *bianmaInfo in bianmaArr) {
           NSArray *bmArr = [bianmaInfo componentsSeparatedByString:@"-"];
           NSString *bm = [bmArr firstObject];
           NSString *ren = [bmArr lastObject];
           if ([info containsString:bm]) {
               NSString *s = [NSString stringWithFormat:@"%@%@%@",info,areaTag,ren];
               NSString *str1 = [s stringByRemovingPercentEncoding];
               [resu addObject:str1];
               break;
           }
           
       }
        index = index + 1;
        NSLog(@"%ld / %ld",(long)index, (long)total);
    }
    return resu;
}

+ (NSMutableArray *)getGoodData {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL loca = [self locationData];
    if (loca) {
        NSMutableArray *loc = [userDefault objectForKey:@"op"];
        if (loc) { return loc; }
    } else {
        [userDefault removeObjectForKey:@"op"];
    }
    [self calculateICanArr]; // 该方法当中，已经找出了sepTag
    NSArray * can = ICanArray;
    // 筛选出我能报考的岗位的，缴费人数
    // 1.得到所有岗位的编码数组
    NSArray *bianmaArr = [self allCodeArray];
    // 2.便利可报考岗位,在可报考岗位后，添加报名人数
    
    NSMutableArray *resu = [self binali:can bianmaArr:bianmaArr];
    
    if (loca) {
        [userDefault setObject:resu forKey:@"op"];
        [userDefault synchronize];
    }
    return resu;
}

+ (NSArray *)allCodeArray {
    NSArray * arr = [self peopleCount];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:3500];
    for (NSString *baseStr in arr) {
        id tag;
        for(int i =0; i < [baseStr length]; i++)
        {
            tag = [baseStr substringWithRange:NSMakeRange(i, 1)];
            NSString *type = NSStringFromClass([tag class]);
            
            if ([type isEqualToString:@"NSTaggedPointerString"]) {
                BOOL isNum = [RegExp validatePassword:tag];
                BOOL isChina = [RegExp validateNickname:tag];
                if (!isChina && !isNum) {
                    break;
                }
            }
        }
        if (tag) {
            NSArray *tempArr = [baseStr componentsSeparatedByString:tag];
            NSString *bm = [tempArr firstObject];
            NSString *rs = [tempArr lastObject];
            
            NSString *code_cou = [NSString stringWithFormat:@"%@-%@",bm,rs];
            [temp addObject:code_cou];
        } else {
            NSLog(@"baseStr = %@",baseStr);
        }
    }
    return temp;
}

+ (NSArray *)peopleCount {
    if (payPeopleCountArray) {
        return payPeopleCountArray;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"myForm" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [content componentsSeparatedByString:@"\n"];
    payPeopleCountArray = arr;
    return payPeopleCountArray;
}

+ (void)calculateICanArr {
    NSArray *arr = [self formData];

    NSMutableArray *array_tatal = [NSMutableArray arrayWithCapacity:100]; // 不分组
    for (NSString *name in arr) {
        NSArray *shiArr = [self getDataSource:name];
        if (sepTag == nil) {
            [self getSepTag:shiArr[0]];
        }
        for (NSString *info in shiArr) {
            BOOL need = ([info containsString:@"不限"] || [info containsString:@"电子商务"]) ;
            
            BOOL noNeed = (![info containsString:@"中共党员"] && ![info containsString:@"口语"] && ![info containsString:@"硕士及以上"] && ![info containsString:@"博士及以上"] && ![info containsString:@"大专及以上"] && ![info containsString:@"学士及以上"] && ![info containsString:@"学士以上"]);
            
            if (need) {
                if (noNeed) {
                    NSString *myInfo = [NSString stringWithFormat:@"%@%@%@",info,groupTag,name];
                    [array_tatal addObject:myInfo];
                }
            }
        }
    }
    
    if (ICanArray == nil) {
        ICanArray = array_tatal;
    }
}


+ (NSArray *)formData {
    NSArray *keys = @[@"省直",@"司法",@"成都",@"雅安",@"遂宁",@"乐山",@"广安",@"宜宾",@"德阳",@"阿坝",@"巴中",@"广元",@"绵阳",@"泸州",@"南充",@"自贡",@"内江",@"资阳",@"甘孜",@"凉山"];
    return keys;
}

+ (NSArray *)getListSource {
    NSArray *keys = @[@"可选岗位汇总",@"可选岗位-分组汇总",@"报名人数汇总"];
    return keys;
}

@end
