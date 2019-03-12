//
//  ContentViewController.m
//  GoodNews
//
//  Created by Stefan on 2019/2/25.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "ContentViewController.h"
#import "NewsModel.h"
#import "TopPicTableViewCell.h"
#import "SignalPicTableViewCell.h"
#import "DetailViewController.h"

@interface ContentViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

static NSString * const singlePictureCell = @"SinglePictureCell";
static NSString * const topPictureCell = @"TopPictureCell";
@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupContentTableView];
    [self setupBasic];
    [self setupRefresh];
    
}
- (void)setupContentTableView
{
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-NAVI_HEIGHT-30-self.tabBarController.tabBar.frame.size.height)];
    tableview.backgroundColor = RGB(250, 250, 250);
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.contentTableView = tableview;
    [self.view addSubview:self.contentTableView];
    
}

- (void)setupBasic
{
    self.contentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentTableView registerNib:[UINib nibWithNibName:@"TopPicTableViewCell" bundle:nil] forCellReuseIdentifier:topPictureCell];
    [self.contentTableView registerNib:[UINib nibWithNibName:@"SignalPicTableViewCell" bundle:nil] forCellReuseIdentifier:singlePictureCell];
}

//初始化刷新控件
- (void)setupRefresh
{
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.contentTableView.mj_header beginRefreshing];
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
- (void)endRefresh
{
    [self.contentTableView.mj_header endRefreshing];
    [self.contentTableView.mj_footer endRefreshing];
}
//上拉刷新
- (void)loadData
{ 
    NSString *urlStr = [NSString stringWithFormat:@"%@nc/article/%@/10-20.html",BaseUrl,self.urlString];
    [self loadDataWithType:1 withURLStr:urlStr];
}


//加载
- (void)loadMoreData
{
    
    NSString *urlStr = [NSString stringWithFormat:@"%@nc/article/%@/%ld-20.html",BaseUrl,self.urlString,self.dataArray.count-self.dataArray.count%10];
    [self loadDataWithType:2 withURLStr:urlStr];
}

- (void)loadDataWithType:(NSInteger)type withURLStr:(NSString *)urlStr
{
    [[NetWorks shareInstance] postWithURLString:urlStr parameters:nil success:^(id  _Nonnull responseObject) {
        NSDictionary *resDic = responseObject;
        NSString *key = [resDic.keyEnumerator nextObject];
        NSArray *tempArr = resDic[key];
        NSArray *arrayM = [NewsModel mj_objectArrayWithKeyValuesArray:tempArr];
        
        if (type == 1) {
            self.dataArray = [arrayM mutableCopy];
            
        }else{
            [self.dataArray addObjectsFromArray:arrayM];
        }
        [self.contentTableView reloadData];
        [self endRefresh];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = self.dataArray[indexPath.row];
    if (model.hasHead && model.photosetID && model.url) {
        TopPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topPictureCell];
        [cell.topImgView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"default-pic"]];
        cell.contentLabel.text = model.title;
        return cell;
    }else if (model.hasHead && model.url) {
        TopPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:topPictureCell];
        [cell.topImgView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"default-pic"]];
        cell.contentLabel.text = model.title;
        return cell;
    }else if(model.url){
        SignalPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
        [cell.newsPicView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"default-pic"]];
        cell.bigTiltle.text = model.title;
        cell.contentText.text = model.digest;
        return cell;
    }else{
        SignalPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:singlePictureCell];
//        [cell.newsPicView sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@""]];
        cell.bigTiltle.text = @"";
        cell.contentText.text = @"";
        return cell;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = self.dataArray[indexPath.row];
    if (model.hasHead && model.photosetID&&model.url){
        return 245;
    }else if (model.hasHead&&model.url) {
        return 245;
    }else if(model.url){
        return 95;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *model = self.dataArray[indexPath.row];
    [self pushDetailControllerWithURLString:model.url];
    
}
- (void)pushDetailControllerWithURLString:(NSString *)urlStr
{
    DetailViewController *controller = [[DetailViewController alloc] init];
    controller.hidesBottomBarWhenPushed = YES;
    controller.urlStr = urlStr;
    [self.navigationController pushViewController:controller animated:YES];
}

@end
