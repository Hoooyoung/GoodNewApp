
//
//  NewsFViewController.m
//  GoodNews
//
//  Created by Stefan on 2019/2/20.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "NewsFViewController.h"
#import "JXCategoryView.h"
#import "ContentViewController.h"

@interface NewsFViewController ()<JXCategoryViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *cateScrollView;
@property (nonatomic, strong) NSArray *arrayLists;
@end

@implementation NewsFViewController

- (NSArray *)arrayLists
{
    if (!_arrayLists) {
        self.arrayLists = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsURLs.plist" ofType:nil]];
    }
    return _arrayLists;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupChirldController];
    [self setupContentScrollView];
    [self createSegmentView];
    
}
- (void)createSegmentView
{
    JXCategoryTitleView *categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, kScreenW, 30)];
    categoryView.backgroundColor = RGB_ALPHA(250, 250, 250,0.5f);
    categoryView.titles = @[@"头条",@"NBA",@"手机",@"移动互联",@"娱乐",@"时尚",@"电影",@"科技"];
    categoryView.titleColor = RGB(74, 74, 74);
    categoryView.titleSelectedColor = THEME_COLOR;
    categoryView.titleFont = [UIFont systemFontOfSize:14];
    categoryView.titleSelectedFont = [UIFont systemFontOfSize:16];
    categoryView.delegate = self;
    categoryView.contentScrollView = _cateScrollView;
    
//    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
//    lineView.indicatorLineWidth = 25;
//    lineView.indicatorLineViewHeight = 2;
//    lineView.indicatorLineViewColor = [UIColor whiteColor];
//    categoryView.indicators = @[lineView];
    [self.view addSubview:categoryView];
    
}
#pragma mark - 子视图
- (void)setupChirldController
{
    for (NSInteger i = 0; i < 8; i++) {
        ContentViewController *contentTvc = [[ContentViewController alloc] init];
        contentTvc.urlString = self.arrayLists[i][@"urlString"];
        [self addChildViewController:contentTvc];
    }
}

- (void)setupContentScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.cateScrollView = scrollView;
    [scrollView setContentSize:CGSizeMake(kScreenW*8, 0)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
#pragma mark----UIScrollviewDelegate---
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSLog(@"DidEndScrollingAnimation");
    if (scrollView == self.cateScrollView) {
        NSInteger index = scrollView.contentOffset.x/kScreenW;
        ContentViewController *tvc = self.childViewControllers[index];
//        if (tvc.isViewLoaded) {
//            return;
//        }
       tvc.contentTableView.frame = tvc.view.frame = CGRectMake(kScreenW*index, NAVI_HEIGHT+30, kScreenW, kScreenH-self.tabBarController.tabBar.frame.size.height-NAVI_HEIGHT-30);
//        tvc.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.tabBarController.tabBar.frame.size.height, 0);
        [scrollView addSubview:tvc.contentTableView];
//        NSLog(@"%@",self.cateScrollView.subviews);
        
        for (int i = 0; i<self.cateScrollView.subviews.count; i++) {
            NSInteger currentIndex = tvc.view.frame.origin.x/self.cateScrollView.frame.size.width;
            if ([self.cateScrollView.subviews[i] isKindOfClass:[UITableView class]]) {
                UITableView *theTableView = self.cateScrollView.subviews[i];
                NSInteger theIndex = theTableView.frame.origin.x/self.cateScrollView.frame.size.width;
                NSInteger gap = theIndex - currentIndex;
                if (gap<=2&&gap>=-2) {
                    continue;
                } else {
                    [theTableView removeFromSuperview];
                }
            }
            
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.cateScrollView) {
        [self scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end
