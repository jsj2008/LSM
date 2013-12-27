//
//  LSMyPhoneCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyPhoneCell.h"

@implementation LSMyPhoneCell

@synthesize imageName=_imageName;
@synthesize title=_title;
@synthesize titleClick=_titleClick;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font=LSFontMyTitle;
        self.textLabel.textColor=LSColorTextBlack;
        
        _bindButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_bindButton setTitleColor:LSColorButtonNormalRed forState:UIControlStateNormal];
        [_bindButton setTitleColor:LSColorButtonHighlightedRed forState:UIControlStateNormal];
        _bindButton.titleLabel.textAlignment=NSTextAlignmentRight;
        _bindButton.titleLabel.font=LSFontMyTitle;
        [_bindButton addTarget:self action:@selector(bindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bindButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.text=_title;
    self.imageView.image=[UIImage lsImageNamed:_imageName];
    
    [_bindButton setTitle:_titleClick forState:UIControlStateNormal];
    _bindButton.frame=CGRectMake(250.f, 0.f, 70.f, self.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark- 私有方法
- (void)bindButtonClick:(UIButton*)sender
{
    [_delegate LSMyPhoneCell:self didClickBindButton:sender];
}

@end
