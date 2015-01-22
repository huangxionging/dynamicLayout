//
//  FriendDynamicModel.h
//  dynamicLayout
//
//  Created by huangxiong on 14-8-18.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendDynamicModel : NSObject

// 头像名字
@property (nonatomic, copy) NSString *headName;

// 名字
@property (nonatomic, copy) NSString *name;

// 名字高度
@property (nonatomic, assign) NSInteger nameHeight;

// 日期
@property (nonatomic, copy) NSString *date;

// 日期高度
@property (nonatomic, assign) NSInteger dateHeight;

// 文本
@property (nonatomic, copy) NSString *text;

// 文本高度
@property (nonatomic, assign) NSInteger textHeight;

@property (nonatomic, assign) NSInteger pictures;

@property (nonatomic, assign) NSInteger pictureHeight;

@property (nonatomic, assign) NSInteger pictureStarts;

// 浏览次数
@property (nonatomic, copy) NSString *browse;

// 用以保存赞的用户
@property (nonatomic, strong) NSMutableString *likes;

@property (nonatomic, assign) NSInteger likesHeight;

// 计数
@property (nonatomic, assign) NSInteger count;

// cell高度
@property (nonatomic, assign) NSInteger cellHeight;

// 用以保存评论的数据
@property (nonatomic, strong) NSMutableArray *comments;

@property (nonatomic, assign) NSInteger commentHeight;

@end
