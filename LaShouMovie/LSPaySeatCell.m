//
//  LSPaySeatCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-11-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPaySeatCell.h"
#import "LSSeat.h"

#define gapL 10.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSPaySeatCell

@synthesize order=_order;
@synthesize delegate=_delegate;

+ (CGFloat)heightForOrder:(LSOrder*)order
{
    CGFloat contentY=gapL;
    
    if (order.schedule)
    {
        NSString* text=[NSString stringWithFormat:@"%@ %@ %@ %@",order.schedule.hall.hallName,order.schedule.language,order.schedule.isIMAX?@"IMAX":@"",order.schedule.dimensional==LSFilmDimensional3D?@"3D":@""];
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    if (order.selectSeatArray)
    {
        NSString* text=[NSString stringWithFormat:@"已选座位: %d张",order.selectSeatArray.count];
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize];
        contentY+=(size.height+5.f);
        
        text=@"";
        for(LSSeat* seat in order.selectSeatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座 ",seat.realRowID,seat.realColumnID]];
        }
        
        size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
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
        [_spreadButton setImage:[UIImage lsImageNamed:@"btn_re_nor.png"] forState:UIControlStateNormal];
        [_spreadButton setImage:[UIImage lsImageNamed:@"btn_re_sel.png"] forState:UIControlStateHighlighted];
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
    [self drawRoundRectangleInRect:CGRectMake(gapL, 0.f, rect.size.width-2*gapL, rect.size.height) topRadius:0.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineGrayColor borderWidth:0.5];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    CGFloat contentY=gapL;
    
    if (_order.schedule)
    {
        NSString* text=[NSString stringWithFormat:@"%@ %@ %@ %@",_order.schedule.hall.hallName,_order.schedule.language,_order.schedule.isIMAX?@"IMAX":@"",_order.schedule.dimensional==LSFilmDimensional3D?@"3D":@""];
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [text drawInRect:CGRectMake(gapL*2, contentY, basicWidth, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    if (_order.selectSeatArray)
    {
        NSString* text=[NSString stringWithFormat:@"已选座位: %d张",_order.selectSeatArray.count];
        CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize];
        [text drawInRect:CGRectMake(gapL*2, contentY, basicWidth, size.height) withFont:LSFont15];
        contentY+=(size.height+5.f);
        
        text=@"";
        for(LSSeat* seat in _order.selectSeatArray)
        {
            text=[text stringByAppendingString:[NSString stringWithFormat:@"%@排%@座 ",seat.realRowID,seat.realColumnID]];
        }
        
        size=[text sizeWithFont:LSFont15 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [text drawInRect:CGRectMake(gapL*2, contentY, basicWidth, size.height) withFont:LSFont15 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }
    
    contentY+=5.f;
}

#pragma mark- 私有方法
- (void)spreadButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSPaySeatCellDidFold)])
    {
        [_delegate LSPaySeatCellDidFold];
    }
}

@end
