//
//  LSGroupInfoPositionCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoPositionCell.h"

#define gapL 20.f
#define basicWidth 180
#define basicFont LSFont15
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSGroupInfoPositionCell

@synthesize cinema=_cinema;
@synthesize delegate=_delegate;

+ (CGFloat)heightOfCinema:(LSCinema*)cinema
{
    CGFloat contentY=15.f;
    
    //影院名
    if(cinema.cinemaName!=nil)
    {
        CGSize size=[cinema.cinemaName sizeWithFont:basicFont constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }
    
    //影院地址
    if (cinema.address!=nil)
    {
        NSString* text=[NSString stringWithFormat:@"%@",cinema.address];
        CGSize size=[text sizeWithFont:LSFont10 constrainedToSize:basicSize];
        contentY+=(size.height+5);
    }
    
    //距离
    if (cinema.distance!=nil)
    {
        NSString* text=[NSString stringWithFormat:@"距离%@",cinema.distance];
        CGSize size=[text sizeWithFont:LSFont10 constrainedToSize:basicSize];
        contentY+=(size.height+5);
    }
    
    return contentY;
}

#pragma mark- 生命周期
- (void)dealloc
{
    self.cinema=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@"schedule_map.png"] forState:UIControlStateNormal];
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@"schedule_map_d.png"] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapButton];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@"schedule_phone.png"] forState:UIControlStateNormal];
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@"schedule_phone_d.png"] forState:UIControlStateHighlighted];
        [_phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_phoneButton];
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
    
    _phoneButton.frame=CGRectMake(self.width-20.f-44.f, (self.height-10.f-44.f)/2+10.f, 44.f, 44.f);
    _mapButton.frame=CGRectMake(self.width-20.f-44.f-10.f-44.f, (self.height-10.f-44.f)/2+10.f, 44.f, 44.f);
}

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect=CGRectMake(10, 10, rect.size.width-2*10, rect.size.height-10);
    [self drawRoundRectangleInRect:bgRect topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    CGFloat contentY=15.f;
    
    //影院名
    if(_cinema.cinemaName!=nil)
    {
        CGSize size=[_cinema.cinemaName sizeWithFont:basicFont constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_cinema.cinemaName drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:basicFont lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }

    //影院地址
    if (_cinema.address!=nil)
    {
        NSString* text=[NSString stringWithFormat:@"%@",_cinema.address];
        CGSize size=[text sizeWithFont:LSFont10 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [text drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:LSFont10 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5);
    }
    
    //距离
    if (_cinema.distance!=nil)
    {
        NSString* text=[NSString stringWithFormat:@"距离%@",_cinema.distance];
        CGSize size=[text sizeWithFont:LSFont10 constrainedToSize:basicSize];
        [text drawInRect:CGRectMake(gapL, contentY, basicWidth, size.height) withFont:LSFont10];
        contentY+=(size.height+5);
    }
}

#pragma mark- 按钮单机方法
- (void)mapButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSGroupInfoPositionCell: didClickMapButton:)])
    {
        [_delegate LSGroupInfoPositionCell:self didClickMapButton:sender];
    }
}
- (void)phoneButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSGroupInfoPositionCell: didClickPhoneButton:)])
    {
        [_delegate LSGroupInfoPositionCell:self didClickPhoneButton:sender];
    }
}

@end
