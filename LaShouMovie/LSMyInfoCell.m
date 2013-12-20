//
//  LSMyInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyInfoCell.h"

#define gapL 20.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSMyInfoCell

+ (CGFloat)heightOfUser
{
    LSUser* user=[LSUser currentUser];
    
    CGFloat contentY=15;

    NSString* type=nil;
    if(user.loginType!=LSLoginTypeNormal)
    {
        type=@"NotNull";
    }
    if(type!=nil)
    {
        CGSize size=[type sizeWithFont:LSFont14 constrainedToSize:basicSize];
        contentY+=(size.height+5);
    }
    
    if(user.userName!=nil)
    {
        CGSize size=[user.userName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByTruncatingTail];
        contentY+=(size.height+5);
    }
    
    if(user.balance!=nil)
    {
        NSString* text = [NSString stringWithFormat:@"账户余额: ￥%.2f",[user.balance floatValue]];
        CGSize size=[text sizeWithFont:LSFont13 constrainedToSize:basicSize];
        contentY+=(size.height+5);
    }
    
    return contentY;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(10.f, 10.f, rect.size.width-2*10.f, rect.size.height-10.f) topRadius:0.f bottomRadius:0.f isBottomLine:NO fillColor:LSRGBA(242, 242, 242, 1.f) strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    LSUser* user=[LSUser currentUser];

    CGFloat contentY=15;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* type=nil;
    if(user.loginType==LSLoginTypeSinaWB)
    {
        type=@"新浪微博用户";
    }
    else if(user.loginType==LSLoginTypeQQWB)
    {
        type=@"腾讯微博用户";
    }
    else if(user.loginType==LSLoginTypeQQ)
    {
        type=@"QQ用户";
    }
    else if(user.loginType==LSLoginTypeAlipay || user.loginType==LSLoginTypeAlipayNotActive)
    {
        type=@"支付宝用户";
    }
    if(type!=nil)
    {
        CGSize size=[type sizeWithFont:LSFont14 constrainedToSize:basicSize];
        [type drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:LSFont14];
        contentY+=(size.height+5);
    }
    
    if(user.userName!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
        
        CGSize size=[user.userName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByTruncatingTail];
        [user.userName drawInRect:CGRectMake(gapL, contentY, size.width, size.height) withFont:LSFont18 lineBreakMode:NSLineBreakByTruncatingTail];
        contentY+=(size.height+5);
    }
    
    if(user.balance!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        
        NSString* text = [NSString stringWithFormat:@"账户余额: ￥%.2f",[user.balance floatValue]];
        CGSize size=[text sizeWithFont:LSFont13 constrainedToSize:basicSize];
        [text drawInRect:CGRectMake(gapL, contentY, size.width, size.height) withFont:LSFont13];
        contentY+=(size.height+5);
    }
}

@end
