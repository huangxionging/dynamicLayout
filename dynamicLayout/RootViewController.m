//
//  RootViewController.m
//  dynamicLayout
//
//  Created by huangxiong on 14-8-18.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "RootViewController.h"
#import "FriendDynamicCell.h"
#import "FriendDynamicModel.h"

// 单击图片产生滚动视图中上边界和下边界的距离

#define SPACE (70)

@interface RootViewController ()<FriendDynamicCellDelegate, UIScrollViewDelegate>

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _friendDynamicArray = [[NSMutableArray alloc] init];
        
        _friendInfo = [NSArray arrayWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"name" ofType: @"plist"]];
        [self setFriendDynamic];
        
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTableViiew];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTableViiew
{
    _tableViiew = [[UITableView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, 20, self.view.frame.size.width, self.view.frame.size.height - 20) style: UITableViewStylePlain];
    
    _tableViiew.dataSource = self;
    _tableViiew.delegate = self;
    
    UIImageView *headView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg"]];
    
    _tableViiew.tableHeaderView = headView;
    
    [self.view addSubview: _tableViiew];
}

#pragma mark---UITableViewDatasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendDynamicArray.count;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Cell";
    
    FriendDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier: cellID];
   
    if (cell == nil)
    {
        cell = [[FriendDynamicCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
    }
    
    
    cell.indexPath = indexPath;
    [cell setFriendCell: _friendDynamicArray[indexPath.row]];
    
    return cell;
}

#pragma mark---UITableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ((FriendDynamicModel *)_friendDynamicArray[indexPath.row]).cellHeight;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDynamicCell *cell = ((FriendDynamicCell *)[tableView cellForRowAtIndexPath: indexPath]) ;
    
    [cell.textField becomeFirstResponder];
    [cell.textField resignFirstResponder];
    
}

- (void) setFriendDynamic
{
    for (NSInteger index = 0; index < 20; ++index)
    {
        FriendDynamicModel *model = [[FriendDynamicModel alloc] init];
        
        model.headName = [NSString stringWithFormat:@"%02ld.jpg", (long)index];
        
        
        model.name = _friendInfo[index][0];
        
        // 计算名字高度
        CGSize size = CGSizeZero;
        
        model.date =  [NSString stringWithFormat: @"2014-08-%02d", arc4random() % 3 + 18];
        
        model.text = _friendInfo
        [index][1];
        
        if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
        {
            
            NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize: 14.0]};
            
            CGSize size = [model.name boundingRectWithSize: CGSizeMake(250, 500) options: NSStringDrawingUsesLineFragmentOrigin attributes: dict context: nil].size;
            
            model.nameHeight = size.height;
            dict = @{NSFontAttributeName: [UIFont systemFontOfSize: 14.0]};
            
            size = [model.text boundingRectWithSize: CGSizeMake(250, 5000) options: NSStringDrawingUsesLineFragmentOrigin attributes: dict context: nil].size;
            
            model.textHeight = size.height + 3;
        }
        else
        {
            size = [model.name sizeWithFont: [UIFont systemFontOfSize: 14.0] constrainedToSize: CGSizeMake(250, 500) lineBreakMode: NSLineBreakByWordWrapping];
            model.nameHeight = size.height;
            size = [model.text sizeWithFont: [UIFont systemFontOfSize: 14.0] constrainedToSize:CGSizeMake(250, 5000) lineBreakMode: NSLineBreakByWordWrapping];
            
            model.textHeight = size.height + 3;
        }
        
        model.pictures = arc4random() % 10;
        model.pictureStarts = arc4random() % 20;
        
        model.browse =  [NSString stringWithFormat: @"浏览了%d次", arc4random() % 150];
        model.cellHeight = (model.textHeight + model.nameHeight) > 60? (model.textHeight + model.nameHeight) : 60;
        
        
        if (model.pictures == 0)
        {
            model.pictureHeight = 0;
        }
        else if (model.pictures <= 3)
        {
            model.pictureHeight = 80;
        }
        else if (model.pictures <= 6)
        {
            model.pictureHeight = 165;
        }
        else
        {
            model.pictureHeight = 250;
        }
        
        model.cellHeight += model.pictureHeight + 200;
        [_friendDynamicArray addObject: model];
    }
}



#pragma mark---FriendDynamicCellDelegate

- (void)likeWithIndexPath:(NSIndexPath *)indexPath
{
    
    FriendDynamicModel *model =  _friendDynamicArray[indexPath.row];
    
    if (model.count == 20)
    {
        return;
    }
    
    FriendDynamicModel *likeModel =  _friendDynamicArray[model.count];
    
    
    
    if (model.count == 19)
    {
        [model.likes appendString: likeModel.name];
    }
    else
    {
        [model.likes appendFormat: @"%@、", likeModel.name];
    }
    
    model.cellHeight -= model.likesHeight;
    
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize: 13.0]};
    
    CGSize size = [model.likes boundingRectWithSize: CGSizeMake(150, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesLineFragmentOrigin attributes: dict context: nil].size;
   
    model.likesHeight = size.height;
    
    model.cellHeight += size.height;
    
    model.count++;
    
    
    
    [_tableViiew reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationNone];
}


- (void) commentWithIndexPath:(NSIndexPath *)indexPath andString:(NSString *)commentString
{
    FriendDynamicModel *model = _friendDynamicArray[indexPath.row];
    
    NSDictionary *dict = @{NSFontAttributeName: [UIFont systemFontOfSize: 13.0]};
    
    CGSize size = [commentString boundingRectWithSize: CGSizeMake(250, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesLineFragmentOrigin attributes: dict context: nil].size;
    
    model.commentHeight += size.height;
    
    model.cellHeight += size.height;
    
    NSInteger height = size.height;
    
    [model.comments addObject: @[commentString, [NSNumber numberWithInteger: height]]];
    
    [_tableViiew reloadRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationNone];
}

- (void) textFieldScrollToVisible:(NSIndexPath *)indexPath
{
    // 保存原来的偏移量
    _contentOffSet = _tableViiew.contentOffset;
    
    FriendDynamicCell *cell = (FriendDynamicCell *)[_tableViiew cellForRowAtIndexPath: indexPath];
    
    CGPoint point = [cell convertRect: cell.textField.frame toView: _tableViiew].origin;
    
    _tableViiew.contentOffset = CGPointMake(0, point.y - 200);
}

- (void) textFieldScrollToOrigin:(NSIndexPath *)indexPath
{
    // 恢复原来的偏移量
    _tableViiew.contentOffset = _contentOffSet;
}

- (void) tapImageWithIndexPath:(NSIndexPath *)indexPath andStartImage:(NSInteger)start
{
    FriendDynamicModel *model = ((FriendDynamicModel *)_friendDynamicArray[indexPath.row]);
    
    [self setScrollViewWithImages: model.pictures + 2];
    
    [self setImageViewsWithFriendDynamicModel: model];
    
    _imageScrollView.contentOffset = CGPointMake((start + 1) * _imageScrollView.frame.size.width, 0);
    
    NSInteger tag = _imageScrollView.contentOffset.x / _imageScrollView.frame.size.width + 500;
    
    [UIView animateWithDuration: 3.0f animations:^
    {
        UIView *subView = [_imageScrollView viewWithTag: tag];
        
        subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
        
        ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
    }];
    
    if (tag - 500 == 1)
    {
        UIView *subView = [_imageScrollView viewWithTag: tag + model.pictures];
        
        subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
        
        ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
    }
    
    if (tag - 500 == model.pictures)
    {
        UIView *subView = [_imageScrollView viewWithTag: 500];
        
        subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
        
        ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
    }
    
}

#pragma mark---设置图片滚动视图
- (void) setScrollViewWithImages: (NSInteger) pictures
{
    // 初始化
    _imageScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 20, _tableViiew.frame.size.width, _tableViiew.frame.size.height)];
    
    // 设置内容大小
    _imageScrollView.contentSize = CGSizeMake(_imageScrollView.frame.size.width * pictures, _imageScrollView.frame.size.height);
    
    // 设置背景颜色
    _imageScrollView.backgroundColor = [UIColor blackColor];
    
    // 分页显示
    _imageScrollView.pagingEnabled = YES;
    
    // 不要反弹
    _imageScrollView.bounces = NO;
    
    // 不要指示器
    _imageScrollView.showsHorizontalScrollIndicator = NO;
    
    // 分配代理
    _imageScrollView.delegate = self;
    
    // 添加到 self.view
    [self.view addSubview: _imageScrollView];
    
    // 单击手势
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOneClick:)];
    
    tapOne.numberOfTapsRequired = 1;
    
    tapOne.numberOfTouchesRequired = 1;
    
    [_imageScrollView addGestureRecognizer: tapOne];
    
}

#pragma mark---图片滚动视图点击事件
- (void) tapOneClick: (UITapGestureRecognizer *)sender
{
    [sender.view removeFromSuperview];
}

#pragma mark---设置图片视图
- (void) setImageViewsWithFriendDynamicModel: (FriendDynamicModel *)model
{
    
    // 创建滚动视图保存 imageView, 以便于放大图片
    UIScrollView *container = [[UIScrollView alloc] initWithFrame: CGRectMake((0) * _imageScrollView.frame.size.width, SPACE, _imageScrollView.frame.size.width, _tableViiew.frame.size.height - SPACE * 2)];
    
    container.tag = 500;
    
    // 创建 imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, _imageScrollView.frame.size.width, container.frame.size.height)];
    
    imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"test%02ld.jpg", (long)(model.pictureStarts + model.pictures - 1) % 20 ]];
    
    // 分配代理
    container.delegate = self;
    
    // 设置最小缩放因子
    container.minimumZoomScale = 0.5;
    
    // 设置最大缩放因子
    container.maximumZoomScale = 3.0;
    
    // 设置内容大小
    container.contentSize = imageView.frame.size;
    
    // 将imageView添加到滚动容器视图上
    [container addSubview: imageView];
    
    // 将滚动容器添加到 水平滚动视图上
    [_imageScrollView addSubview: container];
    
    for (NSInteger index = 0; index < model.pictures; ++index)
    {
        // 创建滚动视图保存 imageView, 以便于放大图片
        UIScrollView *container = [[UIScrollView alloc] initWithFrame: CGRectMake((index + 1) * _imageScrollView.frame.size.width, SPACE, _imageScrollView.frame.size.width, _tableViiew.frame.size.height - SPACE * 2)];
        
        container.tag = index + 1 + 500;
        
        // 创建 imageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, _imageScrollView.frame.size.width, container.frame.size.height)];
        
        imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"test%02ld.jpg", (long)(model.pictureStarts + index) % 20]];
        
        // 分配代理
        container.delegate = self;
        
        // 设置最小缩放因子
        container.minimumZoomScale = 0.5;
        
        // 设置最大缩放因子
        container.maximumZoomScale = 3.0;
        
        // 设置内容大小
        container.contentSize = imageView.frame.size;
        
        // 将imageView添加到滚动容器视图上
        [container addSubview: imageView];
        
        // 将滚动容器添加到 水平滚动视图上
        [_imageScrollView addSubview: container];
    }
    
    // 创建滚动视图保存 imageView, 以便于放大图片
    container = [[UIScrollView alloc] initWithFrame: CGRectMake((model.pictures + 1) * _imageScrollView.frame.size.width, SPACE, _imageScrollView.frame.size.width, _tableViiew.frame.size.height - SPACE * 2)];
    
    container.tag = model.pictures + 500 + 1;
    
    // 创建 imageView
    imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, _imageScrollView.frame.size.width, container.frame.size.height)];
    
    
    imageView.image = [UIImage imageNamed: [NSString stringWithFormat:@"test%02ld.jpg", (long)(model.pictureStarts) % 20 ]];
    
    
    // 分配代理
    container.delegate = self;
    
    // 设置最小缩放因子
    container.minimumZoomScale = 0.5;
    
    // 设置最大缩放因子
    container.maximumZoomScale = 3.0;
    
    // 设置内容大小
    container.contentSize = imageView.frame.size;
    
    // 将imageView添加到滚动容器视图上
    [container addSubview: imageView];
    
    // 将滚动容器添加到 水平滚动视图上
    [_imageScrollView addSubview: container];
}

#pragma mark---UIScrollViewDelegate

// 获得被缩放的视图
- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

// 滚动视图结束减速滚动
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger numbers = scrollView.contentSize.width / scrollView.frame.size.width;
    
   
    NSInteger tag = _imageScrollView.contentOffset.x / _imageScrollView.frame.size.width + 500;
    
    if (tag - 500 == 1)
    {
        UIView *subView = [_imageScrollView viewWithTag: tag + numbers];
        
        subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
        
        ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
    }
    
    [UIView animateWithDuration: 3.0f animations:^
     {
         UIView *subView = [_imageScrollView viewWithTag: tag];
         
         subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
         
         ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
         
     }];
    

    if (_imageScrollView.contentOffset.x == (numbers - 1) * scrollView.frame.size.width)
    {
        _imageScrollView.contentOffset = CGPointMake(scrollView.frame.size.width, 0);
        
        NSInteger tag = _imageScrollView.contentOffset.x / _imageScrollView.frame.size.width + 500;
        
        [UIView animateWithDuration: 3.0f animations:^
         {
             UIView *subView = [_imageScrollView viewWithTag: tag];
             
             subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
             
             ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
         }];
    }
    if (_imageScrollView.contentOffset.x == 0 * scrollView.frame.size.width)
    {
        UIView *subView = [_imageScrollView viewWithTag: tag];
        
        subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
        
        ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
        _imageScrollView.contentOffset = CGPointMake((numbers - 2) * scrollView.frame.size.width, 0);
        
        NSInteger tag = _imageScrollView.contentOffset.x / _imageScrollView.frame.size.width + 500;
        

        [UIView animateWithDuration: 3.0f animations:^
        {
             UIView *subView = [_imageScrollView viewWithTag: tag];
             
             subView.frame = CGRectMake(subView.frame.origin.x, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
             
             ((UIView *)subView.subviews[0]).frame = CGRectMake(0, 0, subView.frame.size.width, _imageScrollView.frame.size.height);
             
         }];
    }
    
}
@end
