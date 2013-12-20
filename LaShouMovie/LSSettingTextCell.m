//
//  LSSettingTextCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSettingTextCell.h"

@implementation LSSettingTextCell

@synthesize text=_text;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _infoLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.backgroundColor=[UIColor clearColor];
        _infoLabel.font=LSFontBold15;
        [self.contentView addSubview:_infoLabel];
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
    self.imageView.frame=CGRectMake(self.imageView.left+10.f, self.imageView.top, self.imageView.width, self.imageView.height);
    self.textLabel.frame=CGRectMake(self.textLabel.left+10.f, self.textLabel.top, self.textLabel.width, self.textLabel.height);
    self.textLabel.backgroundColor=LSColorBgWhiteColor;
    
    CGSize size=[_text sizeWithFont:LSFontBold15 constrainedToSize:CGSizeMake(300.f, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail];
    _infoLabel.frame=CGRectMake(self.width-30.f-size.width, (44.f-size.height)/2, size.width, size.height);
    _infoLabel.text=_text;
}

- (void)drawRect:(CGRect)rect
{
    [self drawRoundRectangleInRect:CGRectMake(10.f, 0.f, 300.f, rect.size.height) topRadius:0.f bottomRadius:3.f isBottomLine:YES fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5];
}

@end
