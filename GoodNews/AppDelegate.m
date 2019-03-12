//
//  AppDelegate.m
//  GoodNews
//
//  Created by Stefan on 2019/2/19.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "AppDelegate.h"
#import <CYLTabBarController.h>
#import "NewsFViewController.h"
#import "NewsSViewController.h"
#import "NewsThViewController.h"
#import "BaseNavViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong)CYLTabBarController *tbc;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self setupViewControllers];
    self.window.rootViewController = self.tbc;
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)setupViewControllers
{
    NewsFViewController *nfc = [[NewsFViewController alloc] init];
    nfc.title = @"首页";
    UIViewController *navNfc = [[BaseNavViewController alloc] initWithRootViewController:nfc];
    NewsSViewController *nsc = [[NewsSViewController alloc] init];
    nsc.title = @"图片";
    UIViewController *navNsc = [[BaseNavViewController alloc] initWithRootViewController:nsc];
    NewsThViewController *nthc = [[NewsThViewController alloc] init];
    nthc.title = @"视频";
    UIViewController *navNthc = [[BaseNavViewController alloc] initWithRootViewController:nthc];
    self.tbc = [[CYLTabBarController alloc] init];
    [self.tbc.tabBar setTintColor:THEME_COLOR];
    [self customTabbarWord];
    [self.tbc setViewControllers:@[
                                   navNfc,
                                   navNsc,
                                   navNthc
                                   ]];
}
- (void)customTabbarWord
{
    NSDictionary *dict1 = @{
                            CYLTabBarItemTitle : @"首页",
                            CYLTabBarItemImage : @"首页未选中",
                            CYLTabBarItemSelectedImage : @"首页",
                            };
    NSDictionary *dict2 = @{
                            CYLTabBarItemTitle : @"图片",
                            CYLTabBarItemImage : @"图片未选中",
                            CYLTabBarItemSelectedImage : @"图片",
                            };
    NSDictionary *dict3 = @{
                            CYLTabBarItemTitle : @"视频",
                            CYLTabBarItemImage : @"视频未选中",
                            CYLTabBarItemSelectedImage : @"视频",
                            };
    
    NSArray *tabBarItemsAttributes = @[ dict1, dict2 ,dict3];
    self.tbc.tabBarItemsAttributes = tabBarItemsAttributes;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
