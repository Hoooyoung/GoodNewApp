//
//  NetWorks.h
//  GoodNews
//
//  Created by Stefan on 2019/2/26.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorks : NSObject

+ (instancetype)shareInstance;

//post
- (void)postWithURLString:(NSString *)URLString
                  parameters:(id _Nullable)parameters
                     success:(void (^)(id responseObject))success
                     failure:(void (^)(NSError *error))failure;

//get
- (void)getWithURLString:(NSString *)URLString
               parameters:(id _Nullable)parameters
                  success:(void (^)(id responseObject))success
                  failure:(void (^)(NSError *error))failure;


@end

NS_ASSUME_NONNULL_END
