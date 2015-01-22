//
//  FriendDynamicCell.m
//  dynamicLayout
//
//  Created by huangxiong on 14-8-18.
//  Copyright (c) 2014年 New-Life. All rights reserved.
//

#import "FriendDynamicCell.h"

#define DYNAMIC_IMAGE_TAG (400)

@implementation FriendDynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        // 头像
         _headView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 5, HEAD_VIEW_HEIGHT, HEAD_VIEW_HEIGHT)];
        [self.contentView addSubview: _headView];
        
        
        // 名字
        _name = [[UILabel alloc] initWithFrame: CGRectMake(HEAD_VIEW_HEIGHT + 5, 5, 100, LABEL_HEIGHT)];
        
        _name.textColor = [UIColor blueColor];
        
        _name.font = [UIFont systemFontOfSize: 14.0];
        
        _name.numberOfLines = 0;
        
        [self.contentView addSubview: _name];
        
        
        // 时间
        _date = [[UILabel alloc] initWithFrame: CGRectMake(240, 5, 70, LABEL_HEIGHT)];
        
        _date.textAlignment = NSTextAlignmentLeft;
        
        _date.numberOfLines = 1;
        
        _date.font = [UIFont systemFontOfSize: 12.0];
        
        _date.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview: _date];
        
        // 文本
        _text = [[UILabel alloc] init];
        
        _text.font = [UIFont systemFontOfSize: 14.0];
        
        _text.numberOfLines = 0;
        
        [self.contentView addSubview: _text];
        
        _imageContainer = [[UIView alloc] init];
        
        [self.contentView addSubview: _imageContainer];
        
        
        
        // 赞按钮
        _likeButton = [UIButton buttonWithType: UIButtonTypeCustom];
        
        _likeButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        
        [_likeButton addTarget: self action: @selector(like) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview: _likeButton];
        
        
        
        // 评论按钮
        _commentButton = [UIButton buttonWithType: UIButtonTypeCustom];
        
        _commentButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        
        [_commentButton addTarget: self action: @selector(comment) forControlEvents: UIControlEventTouchUpInside];
        
        [self.contentView addSubview: _commentButton];
        
        
        // 赞标签
        _likes = [[UILabel alloc] init];
        
        _likes.font = [UIFont systemFontOfSize: 14.0];
        
        _likes.numberOfLines = 0;
        
        _likes.textAlignment = NSTextAlignmentLeft;
        
        _likes.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview: _likes];
        
        // 浏览次数
        _browse = [[UILabel alloc] init];
        
        _browse.font = [UIFont systemFontOfSize: 13.0];
        
        _browse.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview: _browse];
        
        
        // 评论视图
        _commentView = [[UIView alloc] init];
        [self.contentView addSubview: _commentView];
        _commentView.backgroundColor = [UIColor lightGrayColor];
        
        
        // 文本框
        _textField = [[UITextField alloc] init];
        
        _textField.delegate = self;
        
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        
        _textField.placeholder = @"请输入评论";
        
        [self.contentView addSubview: _textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void) setFriendCell: (FriendDynamicModel *)model
{
    // 删除图像
    for (UIView *sub in _imageContainer.subviews)
    {
        [sub removeFromSuperview];
    }
    
    for (UIView *sub in _commentView.subviews)
    {
        [sub removeFromSuperview];
    }
    // 本身大小
    self.frame = CGRectMake(0, 0, 320, model.cellHeight);
    self.contentView.frame = self.frame;
    
   
    // 头像
    _headView.image = [UIImage imageNamed: model.headName];
    
    // 名字矩形
    _name.frame = CGRectMake(HEAD_VIEW_HEIGHT + 5, 5, 100, model.nameHeight + 20);
    
    
    // 名字内容
    _name.text = model.name;
    
    // 时间
    _date.text = model.date;
    
    
    // 说说内容
    _text.frame = CGRectMake(HEAD_VIEW_HEIGHT + 5, 5 + _name.frame.origin.y + _name.frame.size.height, 250, model.textHeight);
    
    _text.text = model.text;
    
    
    _imageContainer.frame =  CGRectMake(HEAD_VIEW_HEIGHT + 5, _name.frame.origin.y + _name.frame.size.height + 5 + _text.frame.size.height, 250, model.pictureHeight);
    
    
    NSInteger insetx = 0, insety = 0;
    
    // 重写图像容器中的图片
    for (NSInteger index = 0; index < model.pictures; ++index)
    {
        UIImageView *dynamicImage = [[UIImageView alloc] initWithFrame: CGRectMake(insetx, insety, 80 - 3, 80 - 3)];
        insetx += 80;
        
        if ((index + 1) % 3 == 0)
        {
            insetx = 0;
            insety += 80;
        }
        
        dynamicImage.image = [UIImage imageNamed: [NSString stringWithFormat:@"test%02ld.jpg", (long)(model.pictureStarts + index) % 20]];
        
        dynamicImage.userInteractionEnabled = YES;
        
        // 为图片注册单击手势
        UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapOneClick:)];
        
        // 单击手势
        tapOne.numberOfTapsRequired = 1;
        
        tapOne.numberOfTouchesRequired = 1;
        
        [dynamicImage addGestureRecognizer: tapOne];
        
        dynamicImage.tag = DYNAMIC_IMAGE_TAG + index;
        
        [_imageContainer addSubview: dynamicImage];
        
    }
    
    
    // 赞按钮布局
    _likeButton.frame = CGRectMake(150, _name.frame.origin.y + _name.frame.size.height + _text.frame.size.height + _imageContainer.frame.size.height + 10, 60, 40);
    
    // 设置图片
    [_likeButton setImage: [UIImage imageNamed: @"icon_bigPicture_praise_clicked"] forState: UIControlStateNormal];
    
    _likeButton.selected = YES;
    
    // 设置标题颜色
    [_likeButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    
    [_likeButton setTitleColor: [UIColor blueColor] forState: UIControlStateSelected];
    
    [_likeButton setTitle: @"赞" forState: UIControlStateNormal];
    
    // 评论按钮
    _commentButton.frame = CGRectMake(_likeButton.frame.origin.x + _likeButton.frame.size.width + 5, _likeButton.frame.origin.y, 60, 40);
    
    [_commentButton setImage: [UIImage imageNamed: @"icon_comment"] forState: UIControlStateNormal];
    
    [_commentButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    
    [_commentButton setTitleColor: [UIColor blueColor] forState: UIControlStateHighlighted];
    
    [_commentButton setTitle: @"评论" forState: UIControlStateNormal];
    
    
    //添加赞的人
    _likes.frame = CGRectMake(60, _likeButton.frame.origin.y + _likeButton.frame.size.height + 10, 250, model.likesHeight);
    
    _likes.text = model.likes;
    
    // 浏览次数
    _browse.frame = CGRectMake(60,_likeButton.frame.origin.y + _likeButton.frame.size.height  + _likes.frame.size.height + 10, 250, 20);
    
    _browse.text = model.browse;
    
    // 评论视图
    _commentView.frame = CGRectMake(_browse.frame.origin.x, _browse.frame.origin.y + _browse.frame.size.height + 5, _browse.frame.size.width, model.commentHeight);
    
    NSInteger space = 0;
    for (NSInteger index = 0; index < model.comments.count; ++index)
    {
        UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(0, space, _commentView.frame.size.width, ((NSNumber *)model.comments[index][1]).integerValue)];
        
        label.numberOfLines = 0;
        
        label.font = [UIFont systemFontOfSize: 13.0];
        
        label.text = model.comments[index][0];
        
        [_commentView addSubview: label];
        space += ((NSNumber *)model.comments[index][1]).integerValue;
    }
    
    _textField.frame = CGRectMake(_commentView.frame.origin.x, _browse.frame.origin.y + _browse.frame.size.height + _commentView.frame.size.height + 10, _commentView.frame.size.width, 30);
    
    
}

- (void) like
{
    if (_delegate && [_delegate respondsToSelector: @selector(likeWithIndexPath:)])
    {
        [_delegate likeWithIndexPath: _indexPath];
    }
}

- (void) comment
{
    [_textField becomeFirstResponder];
}

#pragma mark---UITextFieldDelegate
// 键盘处理
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector: @selector(commentWithIndexPath:andString:)] && [textField.text isEqualToString: @""] == NO)
    {
        [_delegate commentWithIndexPath: _indexPath andString: textField.text];
    }
    [textField resignFirstResponder];
    textField.text = @"";
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector: @selector(textFieldScrollToVisible:)] == YES)
    {
        [_delegate textFieldScrollToVisible: _indexPath];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    if (_delegate && [_delegate respondsToSelector: @selector(textFieldScrollToOrigin:)] == YES)
    {
        [_delegate textFieldScrollToOrigin: _indexPath];
    }
}

#pragma mark---图片单击手势
- (void) tapOneClick: (UITapGestureRecognizer *)sender
{
    if (_delegate && [_delegate respondsToSelector: @selector(tapImageWithIndexPath:andStartImage:)])
    {
        [_delegate tapImageWithIndexPath: _indexPath andStartImage: sender.view.tag - DYNAMIC_IMAGE_TAG];
    }
}

@end
