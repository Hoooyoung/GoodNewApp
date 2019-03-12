//
//  DetailViewController.m
//  GoodNews
//
//  Created by Stefan on 2019/2/26.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupWebview];
}
- (void)setupWebview
{
    [SVProgressHUD show];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, NAVI_HEIGHT, kScreenW, kScreenH-NAVI_HEIGHT)];
    self.webView = webview;
    webview.delegate = self;
    [self.view addSubview:webview];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",error);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.webView stopLoading];
}


@end
