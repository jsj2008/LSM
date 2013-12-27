//
//  LSMyHeaderView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyHeaderView.h"
#define gap 10.f

@implementation LSMyHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _user=[LSUser currentUser];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat contentY=gap;
    CGFloat contentX=gap;
    
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(contentX, contentY, 20.f, 20.f)];
    
    contentX+=(30.f+gap);
    
    NSString* text=nil;
    text=_user.userName;
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-gap, 20.f) withAttributes:[LSAttribute attributeFont:LSFontMySubtitle color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=20.f;
    
    if(_user.loginType==LSLoginTypeNon)
    {
        text=@"(未登录)";
    }
    else if(_user.loginType==LSLoginTypeSinaWB)
    {
        text=@"(新浪微博用户)";
    }
    else if(_user.loginType==LSLoginTypeQQWB)
    {
        text=@"(腾讯微博用户)";
    }
    else if(_user.loginType==LSLoginTypeQQ)
    {
        text=@"(QQ用户)";
    }
    else if(_user.loginType==LSLoginTypeNormal)
    {
        text=@"(拉手土著用户)";
    }
    else if(_user.loginType==LSLoginTypeAlipay || _user.loginType==LSLoginTypeAlipayNotActive)
    {
        text=@"(支付宝用户)";
    }
    else
    {
        text=@"(其他用户)";
    }
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-gap, 10.f) withAttributes:[LSAttribute attributeFont:LSFontMySubtitle color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=10.f;
    
    text=[NSString stringWithFormat:@"余额：￥%@",_user.balance];
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-gap, 15.f) withAttributes:[LSAttribute attributeFont:LSFontMySubtitle color:LSColorWhite lineBreakMode:NSLineBreakByTruncatingTail]];
}

@end
