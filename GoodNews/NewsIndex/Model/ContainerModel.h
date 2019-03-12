//
//  ContainerModel.h
//  GoodNews
//
//  Created by Stefan on 2019/3/4.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class PicsModel,PicInfoModel;
@interface ContainerModel : NSObject
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) PicInfoModel *info;
@end

NS_ASSUME_NONNULL_END
