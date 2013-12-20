//
//  LSFilmInfoDescriptionCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-5.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoDescriptionCell.h"

#define gapL 20.f
#define basicWidth 280.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSFilmInfoDescriptionCell

@synthesize isSpread=_isSpread;
@synthesize film=_film;

+ (CGFloat)heightForFilm:(LSFilm*)film isSpread:(BOOL)isSpread
{
    CGFloat contentY=15.f;
    
    //绘制标题
    NSString* text=@"剧情介绍";
    CGSize size=[text sizeWithFont:LSFont16];
    contentY+=(size.height+5.f);
    
    //绘制信息
    if(film.description)
    {
        if(isSpread)
        {
            size=[film.description sizeWithFont:LSFont13 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        }
        else
        {
            size=[film.description sizeWithFont:LSFont13 constrainedToSize:CGSizeMake(basicWidth, 55.f) lineBreakMode:NSLineBreakByTruncatingTail];
        }
        contentY+=(size.height+5.f);
    }
    contentY+=10.f;
    contentY+=10.f;
    return contentY;
}

- (void)dealloc
{
    self.film=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
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
    [self drawRoundRectangleInRect:CGRectMake(10.f, 10.f, (rect.size.width - 20.f), (rect.size.height - 20.f)) topRadius:3.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5];
    
    CGFloat contentY=15.f;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    //绘制标题
    CGContextSetFillColorWithColor(contextRef, LSColorBlackRedColor.CGColor);
    NSString* text=@"剧情介绍";
    CGSize size=[text sizeWithFont:LSFont16];
    [text drawInRect:CGRectMake(gapL, contentY, size.width, size.height) withFont:LSFont16];
    contentY+=(size.height+5.f);
    

    //绘制信息
    if(_film.description)
    {
        CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
        
        if(_isSpread)
        {
            size=[_film.description sizeWithFont:LSFont13 constrainedToSize:basicSize lineBreakMode:NSLineBreakByCharWrapping];
        }
        else
        {
            size=[_film.description sizeWithFont:LSFont13 constrainedToSize:CGSizeMake(basicWidth, 55.f) lineBreakMode:NSLineBreakByTruncatingTail];
        }
        
        [_film.description drawInRect:CGRectMake(gapL, contentY, size.width, size.height) withFont:LSFont13 lineBreakMode:NSLineBreakByTruncatingTail];
        contentY+=(size.height+5.f);
    }
    contentY+=10.f;
    contentY+=10.f;
    
    //绘制区域颜色，绘制了一个三角形
    CGContextSetStrokeColorWithColor(contextRef, LSColorLineLightGrayColor.CGColor);//设置画笔颜色
    CGContextSetFillColorWithColor(contextRef, LSColorLineLightGrayColor.CGColor);//设置填充颜色
    if (_isSpread)
    {
        CGContextMoveToPoint(contextRef, ((rect.size.width - 10)/2 + 5), (rect.size.height - 22));
        CGContextAddLineToPoint(contextRef, ((rect.size.width - 10)/2 + 10), (rect.size.height - 17));
        CGContextAddLineToPoint(contextRef, (rect.size.width - 10)/2, (rect.size.height - 17));
    }
    else
    {
        CGContextMoveToPoint(contextRef, (rect.size.width - 10)/2, (rect.size.height - 22));
        CGContextAddLineToPoint(contextRef, ((rect.size.width - 10)/2 + 10), (rect.size.height - 22));
        CGContextAddLineToPoint(contextRef, ((rect.size.width - 10)/2 + 5), (rect.size.height - 17));
    }
    CGContextClosePath(contextRef);//闭合路径
    CGContextDrawPath(contextRef, kCGPathFillStroke);//分别给线条和内部上色
}

@end
