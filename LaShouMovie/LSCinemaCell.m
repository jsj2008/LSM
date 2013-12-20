//
//  LSCinemaCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaCell.h"

#define gapL 10.f
#define basicWidth 240.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSCinemaCell

@synthesize cinema=_cinema;

+ (CGFloat)heightForCinema:(LSCinema*)cinema
{
    CGFloat contentY = 7.f;
    CGSize size;
    if (cinema.cinemaName!=nil)
    {
        size = [cinema.cinemaName sizeWithFont:LSFont17 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
    }
    
    contentY+=(size.height+5.f);
    
    //绘制距离
    if(cinema.distance!=nil)
    {
        NSString* text=nil;
        if(![cinema.distance isEqualToString:LSNULL] && [cinema.distance rangeOfString:@"km"].location!=NSNotFound)
        {
            if([[cinema.distance substringToIndex:cinema.distance.length-2] floatValue]>100.f)
            {
                if(![cinema.districtName isEqualToString:LSNULL])
                {
                    text=[NSString stringWithFormat:@"%@",cinema.districtName];
                }
                else
                {
                    text=LSNULL;
                }
            }
            else
            {
                if(![cinema.districtName isEqualToString:LSNULL])
                {
                    text=[NSString stringWithFormat:@"%@(%@)",cinema.distance,cinema.districtName];
                }
                else
                {
                    text=[NSString stringWithFormat:@"%@",cinema.distance];
                }
            }
        }
        else
        {
            text=[NSString stringWithFormat:@"%@(%@)",cinema.distance,cinema.districtName];
        }
        
        size = [text sizeWithFont:LSFont14 constrainedToSize:basicSize];
    }
    
    contentY+=(size.height+7.f);
    return contentY;
}

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
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
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
    [self drawLineAtStartPointX:0 y:rect.size.height endPointX:rect.size.width y:rect.size.height strokeColor:LSColorSeperatorLightGrayColor lineWidth:1.f];
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    CGFloat contentY = 7.f;
    CGFloat contentX=gapL;

    CGSize size;
    if (_cinema.cinemaName!=nil)
    {
        size = [_cinema.cinemaName sizeWithFont:LSFont17 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        [_cinema.cinemaName drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont17 lineBreakMode:NSLineBreakByCharWrapping];
        contentX+=(size.width+5.f);
    }
    
    if (_cinema.buyType == LSCinemaBuyTypeOnlySeat)
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"zuo_icon.png"] top:0 left:0 bottom:25 right:25] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
    }
    else if (_cinema.buyType == LSCinemaBuyTypeOnlyGroup)
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"tuan_icon.png"] top:0 left:0 bottom:25 right:25] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
    }
    else if (_cinema.buyType == LSCinemaBuyTypeSeatGroup)
    {
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"zuo_icon.png"] top:0 left:0 bottom:25 right:25] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
        contentX+=25.f;
        [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"tuan_icon.png"] top:0 left:0 bottom:25 right:25] drawInRect:CGRectMake(contentX, contentY+2.f, 16.f, 16.f)];
    }
    
    contentY+=(size.height+8.f);

    contentX=gapL;
    //绘制距离图标
    [[UIImage lsImageNamed:@"cinemas_distance.png"] drawInRect:CGRectMake(contentX, contentY+3.f, 11.5f, 12.5f)];
    contentX+=15.f;
    
    //绘制距离
    if(_cinema.distance!=nil)
    {
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
        
        CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
        size = [text sizeWithFont:LSFont14 constrainedToSize:basicSize];
        [text drawInRect:CGRectMake(contentX, contentY, 100.f, size.height) withFont:LSFont14 lineBreakMode:NSLineBreakByTruncatingTail];
        contentX+=100.f;
    }
    
    if (_cinema.buyType == LSCinemaBuyTypeOnlySeat || _cinema.buyType == LSCinemaBuyTypeSeatGroup)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor grayColor].CGColor);
        if([_cinema.todayScheduleCount intValue]>0 || [_cinema.totalScheduleCount intValue]>0)
        {
            NSString *text = [NSString stringWithFormat:@"今日 %@ 场",_cinema.todayScheduleCount];
            size = [text sizeWithFont:LSFont14];
            [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont14];
            contentX+=size.width;
            
            contentX+=23.f;
            
            text = [NSString stringWithFormat:@"在售 %@ 场",_cinema.totalScheduleCount];
            size = [text sizeWithFont:LSFont14];
            [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont14];
            contentX+=size.width;
        }
        else
        {
            NSString *text = @"暂无场次";
            size = [text sizeWithFont:LSFont14];
            [text drawInRect:CGRectMake(contentX, contentY, size.width, size.height) withFont:LSFont14];
            contentX+=size.width;
        }
    }
    
    contentY+=(size.height+7.f);
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width - 20.f, (rect.size.height-15.f)/2, 10.f, 15.f)];
}


#pragma mark- 重载触摸方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = LSRGBA(255, 238, 216, 0.6f);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor=[UIColor clearColor];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor clearColor];
    [super touchesCancelled:touches withEvent:event];
}

@end
