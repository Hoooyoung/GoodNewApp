//
//  PicTableViewCell.h
//  GoodNews
//
//  Created by Stefan on 2019/2/27.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PicsModel;

NS_ASSUME_NONNULL_BEGIN

@interface PicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *decContent;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImgView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImgView;

- (void)configCellWithModel:(PicsModel *)model;
+ (CGFloat)getCellHeightWithModel:(PicsModel *)model;
@end

NS_ASSUME_NONNULL_END
