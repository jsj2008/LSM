//
//  LSCinemaFilmCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-13.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaFilmCell.h"

@implementation LSCinemaFilmCell

@synthesize isSelect=_isSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    self.imageView.frame=CGRectInset(self.contentView.frame, 10.f, 5.f);
    
}

- (void)drawRect:(CGRect)rect
{
    if(_isSelect)
    {
        [self drawRectangleInRect:CGRectInset(rect, 7.f, 2.f) borderWidth:0.f fillColor:LSColorButtonNormalRed strokeColor:LSColorButtonNormalRed];
        [[UIImage lsImageNamed:@""] drawInRect:CGRectMake((rect.size.width-7.f)/2, rect.size.height-7.f, 7.f, 7.f)];
    }
}

@end
