//
//  TopPicTableViewCell.h
//  GoodNews
//
//  Created by Stefan on 2019/2/26.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *topImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
