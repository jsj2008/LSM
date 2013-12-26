//
//  LSPayWayCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSPayWayCell.h"

@implementation LSPayWayCell

@synthesize payWay=_payWay;
@synthesize isInitial=_isInitial;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font=LSFontPayTitle;
        self.textLabel.textColor=LSColorTextBlack;
        
        self.detailTextLabel.font=LSFontPaySubtitle;
        self.detailTextLabel.textColor=LSColorTextGray;
        
        _selectImageView=[[[UIImageView alloc] initWithFrame:CGRectMake(0.f, 0.f, 30.f, 30.f)] autorelease];
        self.accessoryView=_selectImageView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.text=_payWay.payWayName;
    self.textLabel.text=_payWay.information;
    
    if(_isInitial)
    {
        _selectImageView.image=[UIImage lsImageNamed:@""];
    }
    else
    {
        _selectImageView.image=[UIImage lsImageNamed:@""];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
