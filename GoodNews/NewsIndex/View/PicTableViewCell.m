//
//  PicTableViewCell.m
//  GoodNews
//
//  Created by Stefan on 2019/2/27.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "PicTableViewCell.h"
#import "PicsModel.h"
#import <SDWebImageDecoder.h>
@interface PicTableViewCell()<SDWebImageManagerDelegate>

@end

@implementation PicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


- (void)configCellWithModel:(PicsModel *)model
{
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.profile_image]placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.personName.text = model.name;
    self.time.text = model.passtime;
    self.decContent.text = model.text;
    
    if ([model.is_gif isEqualToString:@"1"]) {
        self.gifImgView.hidden = NO;
    }else{
        self.gifImgView.hidden = YES;
    }
    self.pictureImgView.contentMode = model.isBigPic == YES?UIViewContentModeScaleToFill:UIViewContentModeScaleAspectFit;
    [self.pictureImgView sd_setImageWithURL:[NSURL URLWithString:[model.is_gif integerValue]==1?model.gifFistFrame:model.image0] placeholderImage:[UIImage imageNamed:@"default-pic"]];
    
    self.pictureImgView.layer.contentsRect = CGRectMake(0, 0, 1, model.isBigPic==YES?((kScreenW-20)*3/4)/([model.height floatValue]*(kScreenW-20)/[model.width floatValue]):1);
    

}

+ (CGFloat)getCellHeightWithModel:(PicsModel *)model
{
    CGFloat cellMagin = 10.0;
    CGFloat otherH = 4 *cellMagin+8;
    CGFloat topH = 35.0;
    CGFloat contentH = [model.text boundingRectWithSize:CGSizeMake(kScreenW-2*cellMagin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
//    NSLog(@"%@---%@===%f===%f",model.width,model.height,kScreenW,kScreenH);
    CGFloat picH = (kScreenW-2*cellMagin)*[model.height floatValue]/[model.width floatValue];
    if (picH >= kScreenH-NAVI_HEIGHT-TABBAR_H) {
        model.isBigPic = YES;
        picH = (kScreenW-20) *3/4;
    }else{
        model.isBigPic = NO;
    }
    
    return otherH + topH + contentH + picH;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
