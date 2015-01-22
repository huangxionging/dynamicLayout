//
//  FriendDynamicCell.h
//  dynamicLayout
//
//  Created by huangxiong on 14-8-18.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendDynamicModel.h"

@protocol FriendDynamicCellDelegate;

#define HEAD_VIEW_HEIGHT (50)
#define LABEL_HEIGHT (40)

@interface FriendDynamicCell : UITableViewCell<UITextFieldDelegate>

// 头像
@property (nonatomic, strong) UIImageView *headView;

// 昵称 名字
@property (nonatomic, strong) UILabel *name;

// 时间日期
@property (nonatomic, strong) UILabel *date;

// 文字内容
@property (nonatomic, strong) UILabel *text;

// 图像容器
@property (nonatomic, strong) UIView *imageContainer;

// 赞按钮
@property (nonatomic, strong) UIButton *likeButton;

// 评论按钮
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UILabel *likes;

@property (nonatomic, strong) UILabel *browse;

//评论视图，用来放置评论图片
@property (nonatomic, strong) UIView *commentView;

@property (nonatomic, assign) id<FriendDynamicCellDelegate> delegate;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void) setFriendCell: (FriendDynamicModel *)model;

@end

@protocol FriendDynamicCellDelegate <NSObject>

@optional

// 点赞
- (void) likeWithIndexPath: (NSIndexPath *)indexPath;

// 评论
- (void) commentWithIndexPath: (NSIndexPath *)indexPath andString: (NSString *)commentString;

// 避免键盘被遮挡, 文本框
- (void) textFieldScrollToVisible: (NSIndexPath *)indexPath;

// 文本框滚回原来位置
- (void) textFieldScrollToOrigin: (NSIndexPath *)indexPath;

// 单击图片代理方法
- (void) tapImageWithIndexPath: (NSIndexPath *) indexPath andStartImage: (NSInteger) start;

@end


