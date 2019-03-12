//
//  NewsSViewController.m
//  GoodNews
//
//  Created by Stefan on 2019/2/20.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "NewsSViewController.h"
#import "PicsModel.h"
#import "PicInfoModel.h"
#import "PicTableViewCell.h"
#import "HZPhotoBrowser.h"

@interface NewsSViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *picTableView;
@property (nonatomic, copy) NSString *maxTime;
@property (nonatomic, strong)NSMutableArray *picArrM;
@end
static NSString *const picCell = @"PicTableViewCell";
@implementation NewsSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupBasic];
    [self setupRefresh];
}

- (void)setupBasic
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, kScreenW, kScreenH-NAVI_HEIGHT-self.tabBarController.tabBar.frame.size.height)];
    self.picTableView = tableView;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 0;
    [self.view addSubview:tableView];
    [self.picTableView registerNib:[UINib nibWithNibName:@"PicTableViewCell" bundle:nil] forCellReuseIdentifier:picCell];
}
- (void)setupRefresh
{
    self.picTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.picTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.picTableView.mj_header beginRefreshing];
}
- (void)loadData
{
    self.maxTime = nil;
    [self requestForPicListWithType:1];
}
- (void)loadMoreData
{
    [self requestForPicListWithType:2];
}

- (void)endRefreshing
{
    [self.picTableView.mj_header endRefreshing];
    [self.picTableView.mj_footer endRefreshing];
}

#pragma mark - network
- (void)requestForPicListWithType:(NSInteger)type
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    if (type == 2) {
        parameters[@"maxtime"] = self.maxTime;
    }
    [[NetWorks shareInstance] postWithURLString:BaseUrl_Pic parameters:parameters success:^(id  _Nonnull responseObject) {
        NSLog(@"dd");
        [self endRefreshing];
        NSDictionary *resDic = responseObject;
        PicInfoModel *picinfoModl = [PicInfoModel mj_objectWithKeyValues:resDic[@"info"]];
        self.maxTime = picinfoModl.maxtime;
        NSArray *tempArr = [PicsModel mj_objectArrayWithKeyValuesArray:resDic[@"list"]];
//        PicsModel *picsM = tempArr[]
        for (PicsModel *picsM in tempArr) {
            picsM.cellHeight = [PicTableViewCell getCellHeightWithModel:picsM];
//            NSLog(@"%f",picsM.cellHeight);
        }
        if (type == 1) {
            self.picArrM = [tempArr mutableCopy];
            
        }else{
            [self.picArrM addObjectsFromArray:tempArr];
        }
        [self.picTableView reloadData];
        [self endRefreshing];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.picArrM.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:picCell];
    PicsModel *model = self.picArrM[indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PicsModel *model = self.picArrM[indexPath.row];
    HZPhotoBrowser *browser = [[HZPhotoBrowser alloc] init];
    browser.isFullWidthForLandScape = YES;
    browser.isNeedLandscape = YES;
    browser.currentImageIndex = 0;
    browser.imageArray =@[model.image0];
    [browser show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PicsModel *pmodel = self.picArrM[indexPath.row];
    
    return pmodel.cellHeight;
}



@end
