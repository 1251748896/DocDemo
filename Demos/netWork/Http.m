//
//  Http.m
//  Http
//
//  Created by HaoHuoBan on 2020/9/28.
//  Copyright © 2020 HaoHuoBan. All rights reserved.
//

#import "Http.h"

#define BASEURL @"http://192.168.1.226:18000"
#define HTTPTIMEOUT 30

#import "BaseModel.h"
@interface NetModel : BaseModel
@property (nonatomic, assign) BOOL animation;
@property (nonatomic, assign) BOOL token;
@property (nonatomic, assign) BOOL callbackError;
@property (nonatomic, assign) BOOL showErrorInfo;
@end
@implementation NetModel
@end

@implementation Http

#pragma mark -----外部方法

+ (void)post:(NSDictionary *)param url:(NSString *)url callback:(nonnull HttpCallback)callback {
    [self post:param url:url config:nil callback:callback];
}

+ (void)get:(NSDictionary *)param url:(NSString *)url callback:(nonnull HttpCallback)callback {
    [self get:param url:url config:nil callback:callback];
}

+ (void)post:(NSDictionary *)param url:(NSString *)url config:(NSDictionary *)config callback:(nonnull HttpCallback)callback {
    NetModel *m = [self handleDefaultConfig:config];
    NSMutableURLRequest *request = [self makeRequest:param url:url config:config httpMethod:@"POST" m:m];
    [self sendRequest:request callback:callback m:m];
}

+ (void)get:(NSDictionary *)param url:(NSString *)url config:(NSDictionary *)config callback:(nonnull HttpCallback)callback {
    NetModel *m = [self handleDefaultConfig:config];
    NSMutableURLRequest *request = [self makeRequest:param url:url config:config httpMethod:@"GET" m:m];
    [self sendRequest:request callback:callback m:m];
}

+ (void)get:(NSDictionary *)param allUrl:(NSString *)url callback:(HttpCallback)callback {
    NetModel *m = [self handleDefaultConfig:nil];
    NSMutableURLRequest *request = [self makeRequest:param url:url config:nil httpMethod:@"GET" m:m];
    [self sendRequest:request callback:callback m:m];
}

#pragma mark -----配置
+ (NetModel *)handleDefaultConfig:(NSDictionary *)config {
    
    NSMutableDictionary *model = @{
        @"animation":@(YES),
        @"token":@(YES),
        @"callbackError": @(YES),
        @"showErrorInfo": @(YES)
    }.mutableCopy;
    
    if (config) {
        for (NSString *key in config) {
            if (config[key]) {
                model[key] = config[key];
            }
        }
    }
    NetModel *m = [[NetModel alloc] initWithDictionary:model];
    return m;
}

#pragma mark -----内部方法

+ (void)sendRequest:(NSMutableURLRequest *)request callback:(HttpCallback)callback m:(NetModel *)m {
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [sharedSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [self handleResult:data error:error m:m callback:callback ];
    }];
    [dataTask resume];
}

+ (void)handleResult:(id)data error:(NSError *)error m:(NetModel *)m callback:(void(^)(id data))callback {
    if (data && (error == nil)) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        if (callback) {
            dispatch_async(dispatch_get_main_queue(), ^{ callback(dic); });
            [self handleCallBack:m msg:@""];
        }
    } else {
      NSLog(@"-----ceshi:error=%@",error);
        if (m.callbackError) {
            dispatch_async(dispatch_get_main_queue(), ^{ callback(@"出错了"); });
        } else {
            [self handleCallBack:m msg:@"出错了"];
        }
    }
}

+ (void)handleCallBack:(NetModel *)m msg:(NSString *)msg {
    if (m.animation) {
        // Toast.hide()
    }
    if (m.showErrorInfo) {
        // Toast.show()
    }
}

+ (NSString *)getAppToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    return token;
}

+ (NSMutableURLRequest *)makeRequest:(NSDictionary *)param url:(NSString *)url config:(NSDictionary *)config httpMethod:(NSString *)type m:(NetModel *)m {
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASEURL,url];
    
    if ([type isEqualToString:@"GET"]) {
        NSString *jsonString = [self convertToJsonString:param];
        urlString = [NSString stringWithFormat:@"%@?%@",urlString,jsonString];
    }
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *temp_URL = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:temp_URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:HTTPTIMEOUT];
    [request setHTTPMethod:type];
    if ([type isEqualToString:@"POST"]) {
        NSError *error;
        NSData *body = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingFragmentsAllowed error:&error];
        if (error) {
            NSLog(@"请求参数转化出错(error), = %@",error);
            NSLog(@"请求参数转化出错(url), = %@",url);
        }
        NSLog(@"body = %@",body);
        [request setHTTPBody:body];
    }
    // 设置header
    
    if (m.token) {
        NSString *token = [self getAppToken];
        NSString *value = [NSString stringWithFormat:@"Bearer %@",token];
        [request addValue:value forHTTPHeaderField:@"Authorization"];
    }
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return request;
}
+ (NSDictionary *)convertToDictionary:(NSString *)jsonStr
{
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *tempDic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    return tempDic;
}

+ (NSString *)convertToJsonString:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    //    NSRange range = {0,jsonString.length};
    //    //去掉字符串中的空格
    //    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

@end
