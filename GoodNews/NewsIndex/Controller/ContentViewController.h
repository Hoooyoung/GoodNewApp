//
//  ContentViewController.h
//  GoodNews
//
//  Created by Stefan on 2019/2/25.
//  Copyright © 2019年 Vanguard. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContentViewController : BaseViewController
@property (nonatomic, strong) UITableView *contentTableView;
@property (nonatomic, copy) NSString *urlString;
@end

NS_ASSUME_NONNULL_END
