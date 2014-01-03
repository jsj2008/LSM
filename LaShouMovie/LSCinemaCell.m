//
//  LSCinemaCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaCell.h"

#define gap 10.f

@implementation LSCinemaCell

@synthesize cinema=_cinema;

-(void)dealloc
{
    self.cinema=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
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
    [super drawRect:rect];
    
    CGFloat contentX=gap;
    CGFloat contentY=gap;
    
    CGRect nameRect;
    //图标大小：16*16
    if (_cinema.buyType == LSCinemaBuyTypeOnlySeat || _cinema.buyType == LSCinemaBuyTypeOnlyGroup)
    {
        nameRect = [_cinema.cinemaName boundingRectWithSize:CGSizeMake(rect.size.width-gap-16.f-5.f-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontCinemaName] context:nil];
    }
    else if (_cinema.buyType == LSCinemaBuyTypeSeatGroup)
    {
        nameRect = [_cinema.cinemaName boundingRectWithSize:CGSizeMake(rect.size.width-gap-16.f-5.f-16.f-5.f-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontCinemaName] context:nil];
    }
    else
    {
        nameRect = [_cinema.cinemaName boundingRectWithSize:CGSizeMake(rect.size.width-gap-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontCinemaName] context:nil];
    }

    [_cinema.cinemaName drawInRect:CGRectMake(contentX, contentY, nameRect.size.width, 25.f) withAttributes:[LSAttribute attributeFont:LSFontCinemaName lineBreakMode:NSLineBreakByTruncatingTail]];
    contentX+=(nameRect.size.width+5.f);
    
    if (_cinema.buyType == LSCinemaBuyTypeOnlySeat)
    {
        [[UIImage lsImageNamed:@"icon_seat.png" ] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
        contentX+=16.f+5.f;
    }
    else if (_cinema.buyType == LSCinemaBuyTypeOnlyGroup)
    {
        [[UIImage lsImageNamed:@"icon_group.png" ] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
        contentX+=16.f+5.f;
    }
    else if (_cinema.buyType == LSCinemaBuyTypeSeatGroup)
    {
        [[UIImage lsImageNamed:@"icon_seat.png" ] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
        contentX+=16.f+5.f;
        [[UIImage lsImageNamed:@"icon_group.png" ] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
    }
    
    contentY+=25.f;
    contentX=gap;

    //绘制距离图标
    [[UIImage lsImageNamed:@""] drawInRect:CGRectMake(contentX, contentY, 30.f, 30.f)];
    contentX+=30.f;
    
    //绘制距离
    NSString* text=nil;
    if(![_cinema.distance isEqualToString:LSNULL] && [_cinema.distance rangeOfString:@"km"].location!=NSNotFound)
    {
        if([[_cinema.distance substringToIndex:_cinema.distance.length-2] floatValue]>100.f)
        {
            if(![_cinema.districtName isEqualToString:LSNULL])
            {
                text=[NSString stringWithFormat:@"%@",_cinema.districtName];
            }
            else
            {
                text=LSNULL;
            }
        }
        else
        {
            if(![_cinema.districtName isEqualToString:LSNULL])
            {
                text=[NSString stringWithFormat:@"%@(%@)",_cinema.distance,_cinema.districtName];
            }
            else
            {
                text=[NSString stringWithFormat:@"%@",_cinema.distance];
            }
        }
    }
    else
    {
        text=[NSString stringWithFormat:@"%@(%@)",_cinema.distance,_cinema.districtName];
    }
    [text drawInRect:CGRectMake(contentX, contentY, 70.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCinemaInfo lineBreakMode:NSLineBreakByTruncatingTail]];
    contentX+=70.f;
    
    if (_cinema.buyType == LSCinemaBuyTypeOnlySeat || _cinema.buyType == LSCinemaBuyTypeSeatGroup)
    {
        if([_cinema.todayScheduleCount intValue]>0 || [_cinema.totalScheduleCount intValue]>0)
        {
            text = [NSString stringWithFormat:@"今日%@场  在售%@场",_cinema.todayScheduleCount,_cinema.totalScheduleCount];
        }
        else
        {
            text = @"暂无场次";
        }
    }
    [text drawInRect:CGRectMake(contentX, contentY, 200.f, 15.f) withAttributes:[LSAttribute attributeFont:LSFontCinemaInfo color:LSColorTextGray lineBreakMode:NSLineBreakByTruncatingTail]];
}

@end
