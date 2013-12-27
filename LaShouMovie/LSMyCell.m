//
//  LSMyCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyCell.h"

#define gap 10.f

@implementation LSMyCell

@synthesize title=_title;
@synthesize imageName=_imageName;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font=LSFontMyTitle;
        self.textLabel.textColor=LSColorTextBlack;
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
    if(_imageName!=nil)
    {
        self.imageView.image=[UIImage lsImageNamed:_imageName];
    }
}

- (void)drawRect:(CGRect)rect
{
    if(_imageName!=nil)
    {
        
    }
}

@end
