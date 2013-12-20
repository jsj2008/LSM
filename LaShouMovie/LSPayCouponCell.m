//
//  LSPayCouponCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayCouponCell.h"

#define gapL 10.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSPayCouponCell

@synthesize order=_order;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.order=nil;
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
        
        _couponButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_couponButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"btn_coupon_nor.png"] top:20 left:10 bottom:20 right:10]  forState:UIControlStateNormal];
        [_couponButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"btn_coupon_sel.png"] top:20 left:10 bottom:20 right:10]  forState:UIControlStateHighlighted];
        [_couponButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _couponButton.titleLabel.font = LSFont15;
        [_couponButton setTitle:@"使用优惠券" forState:UIControlStateNormal];
        [_couponButton addTarget:self action:@selector(spreadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_couponButton];
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
    _couponButton.frame=CGRectMake(self.width-gapL*2-90.f, (self.height-25.f)/2, 90.f, 25.f);
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(gapL, 0.f, rect.size.width-2*gapL, rect.size.height) topRadius:0.f bottomRadius:0.f isBottomLine:NO fillColor:LSColorBgWhiteColor strokeColor:LSColorLineGrayColor borderWidth:0.5];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat contentX=gapL;
    
    if(_order.totalPrice)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        NSString* text = @"优惠券:";
        CGSize size=[text sizeWithFont:LSFont15];
        [text drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, 80.f, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentRight];
        contentX+=(80.f+5.f);
        
        CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
        text = [NSString stringWithFormat:@"%d", _order.couponArray.count];
        size=[text sizeWithFont:LSFontBold20];
        [text drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2-1.f, size.width, size.height) withFont:LSFontBold20];
        contentX+=(size.width+5.f);
        
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        text = @"张";
        size=[text sizeWithFont:LSFont15];
        [text drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15];
        contentX+=size.width;
    }
}

#pragma mark- 私有方法
- (void)spreadButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPayCouponCellDidSelect)])
    {
        [_delegate LSPayCouponCellDidSelect];
    }
}

@end
