//
//  NetWorks.m
//  GoodNews
//
//  Created by Stefan on 2019/2/26.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "NetWorks.h"
#import <AFNetworking.h>

static NetWorks *network = nil;
@implementation NetWorks

+ (instancetype)shareInstance
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[NetWorks alloc] init];
    });
    return network;
}

- (instancetype)init
{
    network = [super init];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知网络");
                break;
                case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有连接网络");
                break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"4G");
                
            default:
                break;
        }
    }];
    return network;
    
}

- (void)getWithURLString:(NSString *)URLString parameters:(id _Nullable)parameters success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSDictionary *respondObjectDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                success(respondObjectDic);
            }else{
                success(responseObject);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postWithURLString:(NSString *)URLString parameters:(id _Nullable)parameters success:(void (^)(id _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.requestSerializer.timeoutInterval = 30;
    [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            if ([responseObject isKindOfClass:[NSData class]]) {
                NSDictionary *respondObjectDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                success(respondObjectDic);
            }else{
                success(responseObject);
            }
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
