//
//  LSCouponCommonCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-28.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCouponCommonCell.h"

#define gapL 10.f
#define basicWidth 280.f

@implementation LSCouponCommonCell

@synthesize coupon=_coupon;
@synthesize topRadius=_topRadius;
@synthesize bottomRadius=_bottomRadius;
@synthesize topMargin=_topMargin;
@synthesize isBottomLine=_isBottomLine;
@synthesize delegate=_delegate;

+ (CGFloat)heightForCoupon:(LSCoupon*)coupon
{
    CGFloat contentY=gapL;
    CGFloat contentX=gapL*2;
    
    NSString* text = @"通兑券";
    CGSize size=[text sizeWithFont:LSFont15];
    contentY+=(size.height+5.f);

    text = [NSString stringWithFormat:@"%@ %@",coupon.exchangeWay,coupon.lessPriceRemind];
    size=[text sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(320.f/2-contentX, INT32_MAX) lineBreakMode:NSLineBreakByCharWrapping];

    contentY+=(size.height+5.f);
    return contentY;
}

#pragma mark- 生命周期
- (void)dealloc
{
    self.coupon=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        
        _deleteButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage lsImageNamed:@"btn_close_nor.png"] forState:UIControlStateNormal];
        [_deleteButton setImage:[UIImage lsImageNamed:@"btn_close_sel.png"] forState:UIControlStateHighlighted];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _deleteButton.frame=CGRectMake(self.width-gapL*2-44.f, (self.height-44.f)/2, 44.f, 44.f);
    
    if(_coupon.couponValid==LSCouponValidValid && _coupon.couponStatus==LSCouponStatusUsed)
    {
        _deleteButton.hidden=NO;
    }
    else
    {
        _deleteButton.hidden=YES;
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(gapL, 0.f, rect.size.width-2*gapL, rect.size.height) topRadius:_topRadius bottomRadius:_bottomRadius isBottomLine:_isBottomLine fillColor:LSColorBgWhiteColor strokeColor:LSColorLineGrayColor borderWidth:0.5];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat contentY=gapL;
    CGFloat contentX=gapL*2;
    
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text = @"通兑券";
    CGSize size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont15];
    contentX+=(size.width+10.f);
    
    if(_coupon.couponID!=nil)
    {
        size=[_coupon.couponID sizeWithFont:LSFont15];
        [_coupon.couponID drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont15];
    }
    
    contentY+=(size.height+5.f);
    contentX=gapL*2;
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    
    if(_coupon.exchangeWay!=nil || _coupon.lessPriceRemind!=nil)
    {
        text = [NSString stringWithFormat:@"%@ %@",_coupon.exchangeWay,_coupon.lessPriceRemind];
        size=[text sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(rect.size.width/2-contentX, INT32_MAX) lineBreakMode:NSLineBreakByCharWrapping];
        [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    contentY+=(size.height+5.f);
    
    contentX=rect.size.width/2+10.f;
    if(_coupon.expireTime!=nil)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        size=[_coupon.expireTime sizeWithFont:LSFont13];
        [_coupon.expireTime drawInRect:CGRectMake(contentX, contentY-5.f-size.height, size.width, size.height) withFont:LSFont13];
    }
    
    if(_coupon.couponValid==LSCouponValidInvalid)
    {
        CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
        text = @"过期或已使用";
        size=[text sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(basicWidth, INT32_MAX)];
        [text drawInRect:CGRectMake(rect.size.width-gapL*2-size.width, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15];
    }
    else if(_coupon.couponStatus==LSCouponStatusUnuse)
    {
        CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
        text = @"未使用";
        size=[text sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(basicWidth, INT32_MAX)];
        [text drawInRect:CGRectMake(rect.size.width-gapL*2-size.width, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15];
    }
}

- (void)deleteButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSCouponCommonCellDidDeleteWithCoupon:)])
    {
        [_delegate LSCouponCommonCellDidDeleteWithCoupon:_coupon];
    }
}

@end
