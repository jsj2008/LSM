//
//  LSMyCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyCell.h"

#define gapL 20
#define basicWidth 280

@implementation LSMyCell

@synthesize category=_category;
@synthesize count=_count;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
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
    CGRect bgRect=CGRectInset(rect, 10.f, 0.f);
    [self drawRoundRectangleInRect:bgRect topRadius:0.f bottomRadius:0.f isBottomLine:NO fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text=nil;
    if(_count!=-1)
    {
        text=[NSString stringWithFormat:@"%@(%d)",_category,_count];
    }
    else
    {
        text=_category;
    }
    CGSize size=[text sizeWithFont:LSFont15 constrainedToSize:CGSizeMake(rect.size.width-2*gapL, rect.size.height)];
    
    CGFloat height=rect.size.height/2-size.height/2;
    [text drawInRect:CGRectMake(gapL, height, size.width, size.height) withFont:LSFont15];
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width-30.f, (rect.size.height-15.f)/2, 10.f, 15.f)];
}

@end
