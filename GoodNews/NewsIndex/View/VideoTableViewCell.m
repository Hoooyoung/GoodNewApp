//
//  VideoTableViewCell.m
//  GoodNews
//
//  Created by Stefan on 2019/3/4.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "VideoTableViewCell.h"
#import "PicsModel.h"
#import <Masonry.h>
#import "VideoPlayView.h"
@interface VideoTableViewCell()
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *decLabel;
@property (nonatomic, strong) UIView *lineview;
@property (nonatomic, strong) PicsModel *model;

@end

@implementation VideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configCell];
    }
    return self;
}
- (void)configCell
{
    
    UIImageView *headImg = [[UIImageView alloc] init];
    [self.contentView addSubview:headImg];
    self.headImgView = headImg;
    [headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).with.offset(10);
        make.height.width.equalTo(@(35));
    }];
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = RGB(85, 85, 85);
    nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headImg.mas_top);
        make.left.equalTo(headImg.mas_right).with.offset(8);
    }];
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.textColor = RGB(85, 85, 85);
    timeLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nameLabel.mas_left);
        make.bottom.equalTo(headImg.mas_bottom);
    }];
    UILabel *decLabel = [[UILabel alloc] init];
    decLabel.textColor = [UIColor blackColor];
    decLabel.font = [UIFont systemFontOfSize:14];
    decLabel.numberOfLines = 0;
    [self.contentView addSubview:decLabel];
    self.decLabel = decLabel;
    [decLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImg.mas_left);
        make.top.equalTo(headImg.mas_bottom).with.offset(10);
        make.right.equalTo(self.contentView).with.offset(-10);
    }];
    
    
    
    UIView *lineview = [[UIView alloc] init];
    lineview.backgroundColor = RGB(239, 239, 239);
    [self.contentView addSubview:lineview];
    [lineview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(@(8));
    }];
    self.lineview = lineview;
    
    UIImageView *vpView = [[UIImageView alloc] init];
//    vpView.backgroundColor = [UIColor redColor];
//    self.theVideoView = vpView;
    [self.contentView addSubview:vpView];
    [vpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10);
        make.width.equalTo(@(50));
        make.top.equalTo(decLabel.mas_bottom).with.offset(10);
        make.bottom.equalTo(lineview.mas_top).with.offset(-10);
    }];
    self.theVideoView = vpView;
    
    UIButton *middlePlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [middlePlayBtn setImage:[UIImage imageNamed:@"白播放"] forState:UIControlStateNormal];
    [middlePlayBtn addTarget:self action:@selector(whitePlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:middlePlayBtn];
    [middlePlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@(45));
        make.center.equalTo(vpView);
    }];
}
- (void)configCellWithModel:(PicsModel *)model
{
    _model = model;
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.profile_image]placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    self.nameLabel.text = model.name;
    self.timeLabel.text = model.passtime;
    self.decLabel.text = model.text;
    [self.theVideoView sd_setImageWithURL:[NSURL URLWithString:model.image0]];
//    self.theVideoView.playItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.videouri]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([self.model.height floatValue]/[self.model.width floatValue]>0.99) {
//        [self.theVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).with.offset(10);
//            //            make.right.equalTo(self.contentView).with.offset(-10);
//            make.top.equalTo(self.decLabel.mas_bottom).with.offset(10);
//            make.bottom.equalTo(self.lineview.mas_top).with.offset(-10);
//
//        }];
        [self.theVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@((kScreenW-20)*2/3));
        }];
    }else{
//        [self.theVideoView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.contentView).with.offset(10);
//            //            make.right.equalTo(self.contentView).with.offset(-10);
//            make.top.equalTo(self.decLabel.mas_bottom).with.offset(10);
//            make.bottom.equalTo(self.lineview.mas_top).with.offset(-10);
//            make.width.equalTo(@(kScreenW-20));
//        }];
        [self.theVideoView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kScreenW-20));
        }];
    }

}

- (void)whitePlay:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(playVideoWithIndex:)]) {
        [self.delegate playVideoWithIndex:self.indexPath];
    }
}

+ (CGFloat)getCellHeightWithModel:(PicsModel *)model
{
    CGFloat cellMargin = 10;
    CGFloat headImgH = 35;
    CGFloat decLabelH = [model.text boundingRectWithSize:CGSizeMake(kScreenW-2*cellMargin, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
//    CGFloat videoViewH =
    CGFloat scale = [model.height floatValue]/[model.width floatValue];
    CGFloat realWidth;
    CGFloat realHeight;
    if (scale > 0.99) {
        realWidth = (kScreenW-20)*2/3;
        
    }else{
        realWidth = kScreenW-20;
        
    }
    realHeight = realWidth *scale;
    return cellMargin*4 + 8 + headImgH + decLabelH + realHeight;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
