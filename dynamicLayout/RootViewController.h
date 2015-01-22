//
//  RootViewController.h
//  dynamicLayout
//
//  Created by huangxiong on 14-8-18.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RootViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

// 表视图
@property (nonatomic, strong) UITableView *tableViiew;

// 存放朋友动态信息
@property (nonatomic, strong) NSMutableArray *friendDynamicArray;

// 存放文字信息
@property (nonatomic, strong) NSArray *friendInfo;

// 存放表视图偏移量
@property (nonatomic, assign) CGPoint contentOffSet;

// 图片滚动视图
@property (nonatomic, strong) UIScrollView *imageScrollView;


- (void) setTableViiew;

- (void) setFriendDynamic;

@end
