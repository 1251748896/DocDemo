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
    return NO;
}

+ (NSMutableArray *)groupArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:30];
    NSMutableArray *showArr = [self getGoodData:NO];
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

+ (NSMutableArray *)getGoodData:(BOOL)useICan {
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    BOOL loca = [self locationData];
    if (loca) {
        NSMutableArray *loc = [userDefault objectForKey:@"op"];
        if (loc) { return loc; }
    } else {
        [userDefault removeObjectForKey:@"op"];
    }
    [self calculateICanArr]; // 该方法当中，已经找出了sepTag
    if (useICan) {
        return ICanArray;
    }
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
        NSArray *tempArr = [baseStr componentsSeparatedByString:@" "];
        NSString *showString = @"";
        for (NSString *obj in tempArr) {
            showString = [NSString stringWithFormat:@"%@-%@",showString,obj];
        }
        [temp addObject:showString];
    }
    return temp;
}

// 报名人数表格数据
+ (NSArray *)peopleCount {
    if (payPeopleCountArray) {
        return payPeopleCountArray;
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:@"报名数量表" ofType:@"txt"];
    NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *arr = [content componentsSeparatedByString:@"\n"];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:arr.count];
    for (NSString *baseStr in arr) {
        NSString *temp = [self replaceSepText:baseStr];
        [array addObject:temp];
    }
    payPeopleCountArray = array;
    return payPeopleCountArray;
}


+ (NSString *)replaceSepText: (NSString *)dataStr {
    NSString *resu = dataStr;
    NSString *temp ;
    for(int i =0; i < [dataStr length]; i++)
    {
        NSRange range = NSMakeRange(i, 1);
        temp = [dataStr substringWithRange:range];
        NSString *type = NSStringFromClass([temp class]);
        BOOL isNum = [RegExp validatePassword:temp];
        BOOL isChina = [RegExp validateNickname:temp];
        if ([type isEqualToString:@"NSTaggedPointerString"] && !isNum && !isChina && [temp intValue] == 0) {
            [resu stringByReplacingCharactersInRange:range withString:@" "];
            break;
        }
    }
    
    return resu;
}

+ (NSArray *)handleForm:(NSArray *)shiArr formName: (NSString *)formName {
    NSMutableArray *array_tatal = [NSMutableArray arrayWithCapacity:100]; // 不分组
    NSLog(@"开始读取%@的数据",formName);
    for (NSString *fo in shiArr) {
        NSString *myStr = [self replaceSepText:fo];
        NSArray *a = [myStr componentsSeparatedByString:@" "];
        NSMutableArray *realArr = [NSMutableArray arrayWithCapacity:30];
        // 去掉纯空格元素
        for (id obj in a) {
            if (![obj isEqualToString:@""]) {
                [realArr addObject:obj];
            }
        }
        BOOL special = NO;  // 专业
        BOOL academic = NO; // 学历
        BOOL degree = NO; // 学位
        BOOL political = NO; // 政治面貌
        BOOL baseExp = NO; // 服务基层项目工作经历
        BOOL qt = NO; // 其他
        
        NSString * zhuanyeStr = @"";
        NSString *xueliStr = @"";
        NSString *xueweiStr = @"";
        NSString *zhengzhimianmaoStr = @"";
        NSString *baseExpStr = @"";
        if (realArr.count > 16) {
            //专业限制 12(M)、学历 13、学位 14、政治面貌 15、备注 17
            zhuanyeStr = realArr[12];
            xueliStr = realArr[13];
            xueweiStr = realArr[14];
            zhengzhimianmaoStr = realArr[15];
            baseExpStr = realArr[17];
            
        }
        special = (
                   [zhuanyeStr containsString:@"不限"]
                   || [zhuanyeStr containsString:@"无要求"]
                   || [zhuanyeStr containsString:@"电子商务"]
//                   [zhuanyeStr containsString:@"管理类"]
                    );
        academic = (
                    [xueliStr containsString:@"本科"]
                    || [xueliStr containsString:@"专"]
                    );
        degree = (
                  [xueweiStr containsString:@"不限"]
                  || [xueweiStr containsString:@"无要求"]
                  || [xueweiStr containsString:@"与最高学历相对应的学位"]
                  || [xueweiStr containsString:@"学士"]
                  );
        political = (
                     ![zhengzhimianmaoStr containsString:@"团员"]
                     && ![zhengzhimianmaoStr containsString:@"党员"]
                     );
        baseExp = (
                   [baseExpStr containsString:@"不限"]
                   || [baseExpStr containsString:@"无限制"]
                   || [baseExpStr containsString:@"无要求"]
                   );
        baseExp = (
        ![baseExpStr containsString:@"村官"]
        && ![baseExpStr containsString:@"三支一扶"]
        );
        
        qt = (
//              ([myStr containsString:@"四川"] || [myStr containsString:@"成都"])
//              ![myStr containsString:@"西部地区和艰苦边远地区职位"]
              ![myStr containsString:@"具有英语六级证书"]
              && ![myStr containsString:@"英语六级"]
              && ![myStr containsString:@"具有英语四级证书"]
              && ![myStr containsString:@"英语四级"]
              && ![myStr containsString:@"限应届高等院校毕业生报考"]
              && ![myStr containsString:@"限高校应届毕业生"]
              && ![myStr containsString:@"30周岁以下"]
              && ![myStr containsString:@"女性"]
              && ![myStr containsString:@"2021年应届高校毕业生"]
              && ![myStr containsString:@"2020年及以后年度毕业的高校毕业生"]
              && ![myStr containsString:@"2019年及以后年度毕业的高校毕业生"]
              && ![myStr containsString:@"2018年及以后年度毕业的高校毕业生"]
              && ![myStr containsString:@"2017年及以后年度毕业的高校毕业生"]
              && ![myStr containsString:@"2016年及以后年度毕业的高校毕业生"]
              && ![myStr containsString:@"2015年及以后年度毕业的高校毕业生"]
              && ![myStr containsString:@"限普通高等学校2021年应届毕业生"]
              );
        if (qt && ([myStr containsString:@"市生源"] || [myStr containsString:@"省生源"] || [myStr containsString:@"县生源"])) {
            if ([myStr containsString:@"四川"] || [myStr containsString:@"成都"] || [myStr containsString:@"简阳"]) {
                qt = YES;
            } else {
                qt = NO;
            }
        }
        if (special && academic && degree && political && baseExp && qt) {
            NSString *myInfo = [NSString stringWithFormat:@"%@%@%@",myStr,groupTag,formName];
            [array_tatal addObject:myInfo];
            
        }
        
    }
    NSLog(@"%@筛选后的数据：%ld",formName,array_tatal.count);
    return array_tatal;
}

+ (void)calculateICanArr {
    
    NSArray *arr1 = [self getDataSource:@"中央党群机关"];
    NSArray *a1 = [self handleForm:arr1 formName:@"中央党群机关"];
    
    NSArray *arr2 = [self getDataSource:@"中央国家机关本级"];
    NSArray *a2 = [self handleForm:arr2 formName:@"中央国家机关本级"];
    
    NSArray *arr3 = [self getDataSource:@"中央国家机关省级及以下级"];
    NSArray *a3 = [self handleForm:arr3 formName:@"中央国家机关省级及以下级"];
    
    NSArray *arr4 = [self getDataSource:@"中央国家行政机关参公事业单位"];
    NSArray *a4 = [self handleForm:arr4 formName:@"中央国家行政机关参公事业单位"];
    NSMutableArray *array_tatal = [NSMutableArray arrayWithCapacity:100]; // 不分组
    [array_tatal addObjectsFromArray:a1];
    [array_tatal addObjectsFromArray:a2];
    [array_tatal addObjectsFromArray:a3];
    [array_tatal addObjectsFromArray:a4];
    
    NSLog(@"共有%ld职位可报考",array_tatal.count);
    for (NSString *obj in array_tatal) {
        NSLog(@"%ld.----%@",[array_tatal indexOfObject:obj],obj);
    }
    if (ICanArray == nil) {
        ICanArray = array_tatal;
    }
    
}


+ (NSArray *)formData {
    NSArray *keys = @[@"中央党群机关",@"中央国家机关本级",@"中央国家机关省级及以下级",@"中央国家行政机关参公事业单位"];
    return keys;
}

+ (NSArray *)getListSource {
    NSArray *keys = @[@"1111",@"222222",@"33333"];
    return keys;
}

+ (NSArray *)sempleArray {
    NSArray *codeArr = [self sempleCodes]; // 可以报名的岗位
    NSArray *formData = [self allCodeArray]; // 所有岗位报名人数统计
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    for (NSString *canCode in codeArr) {
        NSString *w = [[canCode componentsSeparatedByString:@"---"] firstObject];
        for (NSString *info in formData) {
            if ([info containsString:w]) {
                NSString *te = [NSString stringWithFormat:@"%@--%@",canCode,info];
                [array addObject:te];
                break;
            }
        }
    }
    return array;
}

+ (NSArray *)sempleCodes {
    return @[@"33011111---2人",
             @"33006068---1人",
             @"33004055---2人",
             @"33015128---1人",
             @"33014131---1人",
             @"33016158---1人",
             @"33023170---1人",
             @"34015072---2人",
             @"34015080---1人",
             @"31019056---1人",
             @"43012002---2人",
             @"43023003---4人",
             @"43006001---4人",
             @"43015003---2人",
             @"43003001---4人"
    ];
}

@end
