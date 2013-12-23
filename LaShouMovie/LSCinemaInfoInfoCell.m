//
//  LSCinemaInfoInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaInfoInfoCell.h"

#define gap 10.f

@implementation LSCinemaInfoInfoCell

@synthesize cinema=_cinema;

+ (CGFloat)heightForCinema:(LSCinema*)cinema
{
    CGFloat contentY=gap;
    
    CGRect nameRect=[cinema.cinemaName boundingRectWithSize:CGSizeMake(320.f-gap-25.f-gap-25.f-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontCinemaName] context:nil];

    contentY+=(nameRect.size.height+gap);
    
    nameRect=[cinema.address boundingRectWithSize:CGSizeMake(320.f-gap-25.f-gap-25.f-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontCinemaInfo] context:nil];
    
    contentY+=(nameRect.size.height+gap);
    
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
        self.backgroundColor=[UIColor clearColor];
        
        _mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@""] forState:UIControlStateNormal];
        [_mapButton setBackgroundImage:[UIImage lsImageNamed:@""] forState:UIControlStateHighlighted];
        [_mapButton addTarget:self action:@selector(mapButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mapButton];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@""] forState:UIControlStateNormal];
        [_phoneButton setBackgroundImage:[UIImage lsImageNamed:@""] forState:UIControlStateHighlighted];
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
    CGFloat contentX=gap;
    CGFloat contentY=gap;
    
    CGRect nameRect=[_cinema.cinemaName boundingRectWithSize:CGSizeMake(rect.size.width-gap-25.f-gap-25.f-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontCinemaName] context:nil];
    [_cinema.cinemaName drawInRect:CGRectMake(contentX, contentY, nameRect.size.width, nameRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontCinemaName]];
    
    contentY+=(nameRect.size.height+gap);
    
    nameRect=[_cinema.address boundingRectWithSize:CGSizeMake(rect.size.width-gap-25.f-gap-25.f-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontCinemaInfo] context:nil];
    [_cinema.address drawInRect:CGRectMake(contentX, contentY, nameRect.size.width, nameRect.size.height) withAttributes:[LSAttribute attributeFont:LSFontCinemaInfo]];
}


#pragma mark- 按钮单击方法
- (void)mapButtonClick:(UIButton*)sender
{
    [_delegate LSCinemaInfoInfoCell:self didClickMapButton:sender];
}
- (void)phoneButtonClick:(UIButton*)sender
{
    [_delegate LSCinemaInfoInfoCell:self didClickPhoneButton:sender];
}


@end
