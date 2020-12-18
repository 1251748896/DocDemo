//
//  BaseModel.m
//  TongYuan
//
//  Created by 姜波 on 2017/12/6.
//  Copyright © 2017年 姜波. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
@implementation BaseModel
- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self JSON:dic];
    }
    return self;
}

- (void)JSON:(NSDictionary *)dic {
    
    unsigned int propertycount;
    objc_property_t *properties = class_copyPropertyList([self class], &propertycount);
    NSMutableArray *keysArray = [[NSMutableArray alloc] initWithCapacity:propertycount];
    
    for (int i=0; i<propertycount; i++) {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
        [keysArray addObject:propertyName];
        
        id vv = [dic objectForKey:keysArray[i]];
        
        
        if (vv == nil || [vv isEqual:[NSNull null]] || [vv isKindOfClass:[NSNull class]] || [vv isMemberOfClass:[NSNull class]]) {
            
            [self setValue:@"" forKey:keysArray[i]];
            
        } else {
            if ([vv isKindOfClass:[NSArray class]] || [vv isKindOfClass:[UIImage class]] || [vv isKindOfClass:[NSDictionary class]]) {
                
                [self setValue:vv forKey:keysArray[i]];
            } else {
                [self setValue:[NSString stringWithFormat:@"%@",vv] forKey:keysArray[i]];
            }
        }
        
    }
    
    free(properties);
}
@end
