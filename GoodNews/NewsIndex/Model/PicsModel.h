//
//  PicsModel.h
//  GoodNews
//
//  Created by Stefan on 2019/2/27.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicsModel : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profile_image;
@property (nonatomic, copy) NSString *passtime;
@property (nonatomic, copy) NSString *image0;
@property (nonatomic, copy) NSString *image1;
@property (nonatomic, copy) NSString *image2;
@property (nonatomic, copy) NSString *is_gif;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isBigPic;
@property (nonatomic, copy) NSString *gifFistFrame;
@property (nonatomic, copy) NSString *videouri;
@end

NS_ASSUME_NONNULL_END
