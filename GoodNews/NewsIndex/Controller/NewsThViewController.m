//
//  NewsThViewController.m
//  GoodNews
//
//  Created by Stefan on 2019/2/20.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "NewsThViewController.h"
#import "ContainerModel.h"
#import "PicInfoModel.h"
#import "PicsModel.h"
#import "VideoTableViewCell.h"
#import "VideoPlayView.h"

@interface NewsThViewController ()<UITableViewDelegate,UITableViewDataSource,VideoTableViewCellDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *videoTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *maxTime;
@property (nonatomic, strong) VideoPlayView *playView;
@property (nonatomic, strong) VideoTableViewCell *selectedCell;
@end
static NSString *const videoCell = @"VideoTableViewCell";
@implementation NewsThViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTableView];
    [self setupRefresh];
}

- (void)setupTableView
{
    UITableView *tablView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, kScreenW, kScreenH-NAVI_HEIGHT-TABBAR_H)];
    tablView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tablView.dataSource = self;
    tablView.delegate = self;
    tablView.estimatedRowHeight = 0;
    self.videoTableView = tablView;
    [self.view addSubview:tablView];
    [self.videoTableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:videoCell];
    
}
- (void)setupRefresh
{
    self.videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.videoTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    [self.videoTableView.mj_header beginRefreshing];
}
- (void)endRefresh
{
    [self.videoTableView.mj_footer endRefreshing];
    [self.videoTableView.mj_header endRefreshing];
}
- (void)loadData
{
    [self requestWithType:1];
}
- (void)loadMoreData
{
    [self requestWithType:2];
}
- (void)requestWithType:(NSInteger)type
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(41);
    if (type == 2) {
        parameters[@"maxtime"] = self.maxTime;
    }
    [[NetWorks shareInstance] postWithURLString:BaseUrl_Pic parameters:parameters success:^(id  _Nonnull responseObject) {
        NSLog(@"%@",responseObject);
        ContainerModel *model = [ContainerModel mj_objectWithKeyValues:responseObject];
        NSLog(@"%@-----%@",model.info.maxtime,model.list);
        self.maxTime = model.info.maxtime;
        NSArray *tempArr = [NSArray arrayWithArray:model.list];
        for (PicsModel *model in tempArr) {
            model.cellHeight = [VideoTableViewCell getCellHeightWithModel:model];
        }
        if (tempArr.count) {
            if (type == 1) {
                self.dataArray = [tempArr mutableCopy];
            }else{
                [self.dataArray addObjectsFromArray:tempArr];
            }
        }
        
        [self.videoTableView reloadData];
        [self endRefresh];
    } failure:^(NSError * _Nonnull error) {
        [self endRefresh];
        NSLog(@"%@",error);
    }];
}
#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell];
    PicsModel *model = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    [cell configCellWithModel:model];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PicsModel *model = self.dataArray[indexPath.row];
    return model.cellHeight;
}

- (void)playVideoWithIndex:(NSIndexPath *)indexPath
{
    [self.playView resetPlayView];
    VideoTableViewCell *cell = [self.videoTableView cellForRowAtIndexPath:indexPath];
    self.selectedCell = cell;
    VideoPlayView *videoPView = [[VideoPlayView alloc] initWithFrame:cell.theVideoView.frame];
    self.playView = videoPView;
    [cell.contentView addSubview:videoPView];
    PicsModel *model = self.dataArray[indexPath.row];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.videouri]];
    videoPView.playItem = item;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [self.videoTableView indexPathForCell:self.selectedCell];
    if (![self.videoTableView.indexPathsForVisibleRows containsObject:indexPath]) {
        [self.playView resetPlayView];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.playView resetPlayView];
}

@end
