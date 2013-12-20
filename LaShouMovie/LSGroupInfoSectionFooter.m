//
//  LSGroupInfoSectionFooter.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoSectionFooter.h"

@implementation LSGroupInfoSectionFooter

@synthesize group=_group;
@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor lightGrayColor];
        
        _buyButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_detail_tag_r_up.png"] top:4 left:4 bottom:4 right:4] forState:UIControlStateNormal];
        [_buyButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"my_group_order_detail_tag_r_down.png"] top:4 left:4 bottom:4 right:4] forState:UIControlStateHighlighted];
        [_buyButton addTarget:self action:@selector(buyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _buyButton.frame = CGRectMake(self.width-10.f-118.f,(self.height-44.f)/2,118.f,44.f);
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
     
     CGFloat contentX=20.f;
     
     CGContextRef contextRef = UIGraphicsGetCurrentContext();
     
     CGContextSetFillColorWithColor(contextRef, [UIColor redColor].CGColor);
     NSString* text = [[NSString stringWithFormat:@"￥%.2f", _group.price] stringByReplacingOccurrencesOfString:@".00" withString:@""];
     CGSize size=[text sizeWithFont:LSFontBold18];
     [text drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFontBold18];
     contentX+=size.width+10;
     
     CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
     text = [[NSString stringWithFormat:@"￥%.2f", _group.initialPrice] stringByReplacingOccurrencesOfString:@".00" withString:@""];
     size=[text sizeWithFont:LSFont15];
     [text drawInRect:CGRectMake(contentX, (rect.size.height-size.height)/2, size.width, size.height) withFont:LSFont15];
     
     [self drawLineAtStartPointX:contentX y:rect.size.height/2 endPointX:contentX+size.width y:rect.size.height/2 strokeColor:[UIColor grayColor] lineWidth:1.f];
 }
 

- (void)buyButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSGroupInfoSectionFooter: didClickBuyButton:)])
    {
        [_delegate LSGroupInfoSectionFooter:self didClickBuyButton:sender];
    }
}

@end
