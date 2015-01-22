//
//  FriendDynamicModel.m
//  dynamicLayout
//
//  Created by huangxiong on 14-8-18.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "FriendDynamicModel.h"

@implementation FriendDynamicModel

- (id)init
{
    self = [super init];
    if (self)
    {
        _likes = [[NSMutableString alloc] init];
        _comments = [[NSMutableArray alloc] init];
    }
    
    return self;
}

@end
