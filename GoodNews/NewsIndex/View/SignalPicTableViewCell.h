//
//  SignalPicTableViewCell.h
//  GoodNews
//
//  Created by Stefan on 2019/2/26.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignalPicTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsPicView;
@property (weak, nonatomic) IBOutlet UILabel *bigTiltle;
@property (weak, nonatomic) IBOutlet UILabel *contentText;

@end

NS_ASSUME_NONNULL_END
