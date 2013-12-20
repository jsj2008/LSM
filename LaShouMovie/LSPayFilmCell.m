//
//  LSPayFilmCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayFilmCell.h"

#define gapL 10.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSPayFilmCell

@synthesize order=_order;
@synthesize isSpread=_isSpread;
@synthesize delegate=_delegate;

+ (CGFloat)heightForOrder:(LSOrder*)order
{
    CGFloat contentY=gapL*2;
    
    if (order.film.filmName!=nil)
    {
        CGSize size=[order.film.filmName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    if (order.cinema.cinemaName!=nil)
    {
        CGSize size=[order.cinema.cinemaName sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    if (order.schedule)
    {
        NSString* text=[NSString stringWithFormat:@"%@ %@",order.schedule.startDate,order.schedule.startTime];
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    contentY+=5.f;
    
    return contentY;
}

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
        
        _spreadButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_spreadButton setImage:[UIImage lsImageNamed:@"btn_sp_nor.png"] forState:UIControlStateNormal];
        [_spreadButton setImage:[UIImage lsImageNamed:@"btn_sp_sel.png"] forState:UIControlStateHighlighted];
        [_spreadButton addTarget:self action:@selector(spreadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_spreadButton];
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
    _spreadButton.frame=CGRectMake(self.width-gapL*2-25.f, self.height-gapL-25.f, 25.f, 25.f);
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(gapL, gapL, rect.size.width-2*gapL, rect.size.height-gapL) topRadius:3.f bottomRadius:_isSpread?0.f:3.f isBottomLine:!_isSpread fillColor:LSColorBgWhiteColor strokeColor:LSColorLineGrayColor borderWidth:0.5];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    CGFloat contentY=gapL*2;
    
    if (_order.film.filmName!=nil)
    {
        CGSize size=[_order.film.filmName sizeWithFont:LSFont18 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_order.film.filmName drawInRect:CGRectMake(gapL*2, contentY, basicWidth, size.height) withFont:LSFont18 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    if (_order.cinema.cinemaName!=nil)
    {
        CGSize size=[_order.cinema.cinemaName sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_order.cinema.cinemaName drawInRect:CGRectMake(gapL*2, contentY, basicWidth, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    if (_order.schedule)
    {
        NSString* text=[NSString stringWithFormat:@"%@ %@",_order.schedule.startDate,_order.schedule.startTime];
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [text drawInRect:CGRectMake(gapL*2, contentY, basicWidth, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    contentY+=5.f;
}

#pragma mark- 私有方法
- (void)spreadButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPayFilmCellDidSpread)])
    {
        [_delegate LSPayFilmCellDidSpread];
    }
    _spreadButton.hidden=YES;
    _isSpread=YES;
}

#pragma mark- 公有方法
- (void)showSpreadButton
{
    _spreadButton.hidden=NO;
    _isSpread=NO;
}

@end
