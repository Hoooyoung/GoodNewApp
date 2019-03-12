//
//  VideoPlayView.h
//  GoodNews
//
//  Created by Stefan on 2019/3/5.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
//@protocol VideoPlayViewDelegate <NSObject>
//
//- (void)playVideoWithURLString:(NSString *)urlStr;
//
//@end
@interface VideoPlayView : UIView
//@property (nonatomic, weak) id <VideoPlayViewDelegate>delegate;
@property (nonatomic, strong) AVPlayerItem *playItem;

- (void)resetPlayView;
@end

NS_ASSUME_NONNULL_END
