//
//  LSCinemaInfoInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoInfoCell.h"

#define gapL 10.f
#define basicWidth 200.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSCinemaInfoInfoCell

@synthesize cinema=_cinema;

+ (CGFloat)heightForCinema:(LSCinema*)cinema
{
    CGFloat contentY=8.f;

    if (cinema.cinemaName)
    {
        CGSize size=[cinema.cinemaName sizeWithFont:LSFont17 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    if (cinema.address)
    {
        CGSize size=[cinema.address sizeWithFont:LSFont14 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    
    return contentY;
}

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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_map.png"] forState:UIControlStateNormal];
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_map_d.png"] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapButton];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_phone.png"] forState:UIControlStateNormal];
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@"cinema_info_phone_d.png"] forState:UIControlStateHighlighted];
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
    
    _phoneButton.frame = CGRectMake(self.width-10.f-45.f, (self.height-35.f)/2, 45.f, 35.f);
    _mapButton.frame = CGRectMake(self.width-10.f-45.f-8.f-45.f, (self.height-35.f)/2, 45.f, 35.f);
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(0.f, 0.f, rect.size.width, rect.size.height) topRadius:0.f bottomRadius:0.f isBottomLine:NO fillColor:LSColorBgGrayColor strokeColor:LSColorBgGrayColor borderWidth:0.f];
    
    [self drawLineAtStartPointX:0 y:(rect.size.height-2.f) endPointX:rect.size.width y:(rect.size.height-2-6) strokeColor:LSColorLineWhiteColor lineWidth:0];
    
    [self drawLineAtStartPointX:0 y:(rect.size.height-1.f) endPointX:rect.size.width y:(rect.size.height-1-6) strokeColor:LSColorLineGrayColor lineWidth:0];
    
    CGFloat contentY=8.f;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (_cinema.cinemaName)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        CGSize size=[_cinema.cinemaName sizeWithFont:LSFont17 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_cinema.cinemaName drawInRect:CGRectMake(gapL, contentY, size.width, size.height) withFont:LSFont17 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
    if (_cinema.address)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
        CGSize size=[_cinema.address sizeWithFont:LSFont14 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_cinema.address drawInRect:CGRectMake(gapL, contentY, size.width, size.height) withFont:LSFont14 lineBreakMode:NSLineBreakByCharWrapping];
        contentY+=(size.height+5.f);
    }
}


#pragma mark- 按钮单击方法
- (void)mapButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSCinemaInfoInfoCell: didClickMapButton:)])
    {
        [_delegate LSCinemaInfoInfoCell:self didClickMapButton:sender];
    }
}
- (void)phoneButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSCinemaInfoInfoCell: didClickPhoneButton:)])
    {
        [_delegate LSCinemaInfoInfoCell:self didClickPhoneButton:sender];
    }
}


@end
