//
//  LSGroupInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupPayCell.h"

@implementation LSGroupPayCell

@synthesize topRadius=_topRadius;
@synthesize bottomRadius=_bottomRadius;
@synthesize isBottomLine=_isBottomLine;
@synthesize infoLabel=_infoLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _infoLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.backgroundColor=[UIColor clearColor];
        _infoLabel.textColor=self.textLabel.textColor;
        _infoLabel.lineBreakMode=NSLineBreakByWordWrapping;
        [self addSubview:_infoLabel];
        [_infoLabel release];
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
    self.textLabel.font=LSFont15;
    self.textLabel.textColor=LSRGBA(138, 138,138, 1.f);
    self.textLabel.frame=CGRectMake(self.textLabel.left+10, self.textLabel.top, self.textLabel.width, self.textLabel.height);
    self.textLabel.backgroundColor=[UIColor clearColor];
    
    _infoLabel.font=self.textLabel.font;
    CGSize size=[_infoLabel.text sizeWithFont:_infoLabel.font constrainedToSize:CGSizeMake(180.f, self.height) lineBreakMode:NSLineBreakByWordWrapping];
    _infoLabel.frame=CGRectMake(self.width-size.width-20, (self.height-size.height)/2, size.width, size.height);
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(10.f, 0.f, rect.size.width-2*10.f, rect.size.height) topRadius:_topRadius bottomRadius:_bottomRadius isBottomLine:_isBottomLine fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    CGContextSetStrokeColorWithColor(contextRef, LSColorLineLightGrayColor.CGColor);
//    CGContextSetFillColorWithColor(contextRef, LSColorBgWhiteColor.CGColor);
//    
//    CGContextSetAllowsAntialiasing(contextRef,true);
//    CGContextSetLineWidth(contextRef, 1.f);
//	CGRect rrect = CGRectMake((10 + 1.f / 2), 1.f/2, (300 - 1.f), (rect.size.height-(_isBottomLine?1.f:0.f)));
//	
//	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
//	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
//    CGContextMoveToPoint(contextRef, minx, midy);
//    CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, _topRadius);
//    CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, _topRadius);
//    CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, _bottomRadius);
//    CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, _bottomRadius);
//    CGContextClosePath(contextRef);
//	CGContextDrawPath(contextRef, kCGPathFillStroke);
}

@end
