//
//  VideoTableViewCell.h
//  GoodNews
//
//  Created by Stefan on 2019/3/4.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class PicsModel;
@class VideoPlayView;
@protocol VideoTableViewCellDelegate <NSObject>

- (void)playVideoWithIndex:(NSIndexPath *)indexPath;

@end

@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *theVideoView;
@property (nonatomic, weak) id<VideoTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configCellWithModel:(PicsModel *)model;
+ (CGFloat)getCellHeightWithModel:(PicsModel *)model;

@end

