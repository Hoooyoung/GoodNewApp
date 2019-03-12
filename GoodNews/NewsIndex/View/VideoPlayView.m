//
//  VideoPlayView.m
//  GoodNews
//
//  Created by Stefan on 2019/3/5.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "VideoPlayView.h"
#import <Masonry.h>
@interface VideoPlayView()
@property (nonatomic, strong) AVPlayer *avPlayer;
@property (nonatomic, strong) AVPlayerLayer *avlayer;
@property (nonatomic, strong) UIImageView *backImgView;
@property (nonatomic, strong) UIView *toolView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *fullBtn;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UILabel *playTimeLabel;
@property (nonatomic, assign) BOOL isShowTool;

@property (nonatomic, copy) NSString *currentTimeStr;
@property (nonatomic, copy) NSString *totalTimeStr;

@property (nonatomic, strong) UIView *videoParentView;
@property (nonatomic, assign) CGRect videoFrame;
@end

@implementation VideoPlayView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configVideoView];
    }
    return self;
}
- (void)configVideoView
{
//    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:<#(nonnull NSURL *)#>
    
    
    UIImageView *backImg = [[UIImageView alloc] init];
    backImg.backgroundColor = RGB(74, 74, 74);
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [backImg addGestureRecognizer:tgr];
    backImg.userInteractionEnabled = YES;
    [self addSubview:backImg];
    
    self.backImgView = backImg;
    
    AVPlayer *player = [[AVPlayer alloc] init];
    AVPlayerLayer *avlayer = [AVPlayerLayer playerLayerWithPlayer:player];
//    avlayer.frame = self.bounds;
    [backImg.layer addSublayer:avlayer];
    self.avPlayer = player;
    self.avlayer = avlayer;
    
    UIView *toolView = [[UIView alloc] init];
    toolView.backgroundColor = RGB_ALPHA(74, 74, 74,0.5);
    [self addSubview:toolView];
    
    self.toolView = toolView;
    self.toolView.alpha = 0;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setContentMode:UIViewContentModeScaleToFill];
    [playBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    playBtn.selected = YES;
    [playBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [playBtn setImage:[UIImage imageNamed:@"红播放"] forState:UIControlStateNormal];
    [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateSelected];
    [toolView addSubview:playBtn];
    
    self.playBtn = playBtn;
    
    UIButton *fullBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullBtn setImageEdgeInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    [fullBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
    [fullBtn setImage:[UIImage imageNamed:@"取消全屏"] forState:UIControlStateSelected];
    [fullBtn addTarget:self action:@selector(fullScreen:) forControlEvents:UIControlEventTouchUpInside];
    [toolView addSubview:fullBtn];
    
    self.fullBtn = fullBtn;
    
    UILabel *playTimeLabel = [[UILabel alloc] init];
    playTimeLabel.text = @"fdssekso";
    playTimeLabel.textColor = [UIColor whiteColor];
    [toolView addSubview:playTimeLabel];
    
    self.playTimeLabel = playTimeLabel;


    UISlider *progressSlider = [[UISlider alloc] init];
    [progressSlider setThumbImage:[UIImage imageNamed:@"圆"] forState:UIControlStateNormal];
    progressSlider.minimumTrackTintColor = THEME_COLOR;
    [progressSlider addTarget:self action:@selector(moveAction:) forControlEvents:UIControlEventValueChanged];
    [toolView addSubview:progressSlider];
    
    self.progressSlider = progressSlider;
    
    self.isShowTool = NO;
}

- (void)tapAction:(UITapGestureRecognizer *)tgr
{
    [UIView animateWithDuration:0.5f animations:^{
        if (self.isShowTool) {
            self.toolView.alpha = 0;
            self.isShowTool = NO;
        }else{
            self.toolView.alpha = 1;
            self.isShowTool = YES;
        }
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
//        make.top.left.equalTo(self);
//        make.bottom.right.equalTo(self);
    }];
    
    
    self.avlayer.frame = self.bounds;
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@(50));
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.toolView).with.offset(0);
        make.height.width.equalTo(@(50));
    }];
    
    [self.fullBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toolView).with.offset(0);
        make.centerY.equalTo(self.toolView.mas_centerY);
        make.height.width.equalTo(@(50));
        
    }];
    
    [self.playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fullBtn.mas_left).with.offset(-10);
        make.centerY.equalTo(self.toolView);
        make.width.equalTo(@(95));
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playBtn.mas_right).with.offset(10);
        make.right.equalTo(self.playTimeLabel.mas_left).with.offset(-10);
        make.centerY.equalTo(self.toolView.mas_centerY);
    }];
}

#pragma mark - setVideo

- (void)moveAction:(UISlider *)slider
{
    CGFloat currenTime = CMTimeGetSeconds(self.avPlayer.currentItem.duration)*slider.value;
    [self.avPlayer seekToTime:CMTimeMakeWithSeconds(currenTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self.avPlayer play];
    self.playBtn.selected = YES;
    
}

- (void)setPlayItem:(AVPlayerItem *)playItem
{
    _playItem = playItem;
    [self.avPlayer replaceCurrentItemWithPlayerItem:playItem];
//    [self.playItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.avPlayer play];
    [self getTimeString];
    
}
//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
//    AVPlayerItem *item = (AVPlayerItem *)object;
//    if (item.status == AVPlayerItemStatusReadyToPlay) {
////        [self.progressView stopAnimating];
//    }
//}
- (void)playVideo:(UIButton*)btn
{
    btn.selected = !btn.selected;
    if (btn.selected) {
        [self.avPlayer play];
    }else{
        [self.avPlayer pause];
    }
    
}

- (void)fullScreen:(UIButton *)btn
{
//    UIDevice.current.setValue(value, forKey: "orientation");
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [UIDevice.currentDevice setValue:value forKey:@"orientation"]; 这是整个屏幕旋转
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.videoFrame = self.frame;
        self.videoParentView = self.superview;
        
        CGRect rectInWindow = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
        [self removeFromSuperview];
        self.frame = rectInWindow;
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        [UIView animateWithDuration:0.5f animations:^{
            self.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.bounds = CGRectMake(0, 0, CGRectGetHeight(self.superview.bounds), CGRectGetWidth(self.superview.bounds));
            self.center = CGPointMake(CGRectGetMidX(self.superview.bounds), CGRectGetMidY(self.superview.bounds));
        } completion:^(BOOL finished) {
            
        }];
    }else{
        CGRect frame = [self.videoParentView convertRect:self.videoFrame toView:[UIApplication sharedApplication].keyWindow];
        [UIView animateWithDuration:0.5 animations:^{
            self.transform = CGAffineTransformIdentity;
            self.frame = frame;
        } completion:^(BOOL finished) {
            /*
             * movieView回到小屏位置
             */
            [self removeFromSuperview];
            self.frame = self.videoFrame;
            [self.videoParentView addSubview:self];
//            self.movieView.state = MovieViewStateSmall;
        }];
    }
   
}

- (void)getTimeString
{
//    NSTimeInterval duration = CMTimeGetSeconds(self.avPlayer.currentItem.duration);
//    NSTimeInterval currentTime = CMTimeGetSeconds(self.avPlayer.currentTime);
    __weak VideoPlayView *weakSelf = self;
    [self.avPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        CGFloat currenTime = CMTimeGetSeconds(time);
        CGFloat total = CMTimeGetSeconds(weakSelf.avPlayer.currentItem.duration);
        NSInteger min_cur = currenTime/60;
        NSInteger sec_cur = (NSInteger)currenTime%60;
        
        NSInteger min_tot = total/60;
        NSInteger sec_tot = (NSInteger)total%60;
        
        weakSelf.currentTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)min_cur,(long)sec_cur];
        weakSelf.totalTimeStr = [NSString stringWithFormat:@"%02ld:%02ld",(long)min_tot,(long)sec_tot];
        weakSelf.playTimeLabel.text = [NSString stringWithFormat:@"%@/%@",weakSelf.currentTimeStr,weakSelf.totalTimeStr];
        weakSelf.progressSlider.value = currenTime/total;
    }];
}

- (void)resetPlayView
{
    [self.avlayer removeFromSuperlayer];
    [self.avPlayer replaceCurrentItemWithPlayerItem:nil];
    self.avlayer = nil;
    [self removeFromSuperview];
}

@end
