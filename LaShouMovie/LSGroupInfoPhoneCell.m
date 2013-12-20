//
//  LSGroupInfoPhoneCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoPhoneCell.h"

@implementation LSGroupInfoPhoneCell

@synthesize delegate=_delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_phoneButton setTitle:[NSString stringWithFormat:@"客服电话:%@", lsServicePhoneCall] forState:UIControlStateNormal];
        _phoneButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_phoneButton setTitleColor:LSRGBA(76, 76, 76, 1) forState:UIControlStateNormal];
        [_phoneButton setBackgroundImage:[[UIImage lsImageNamed:@"btn_88_gray_click.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateHighlighted];
        [_phoneButton setBackgroundImage:[[UIImage lsImageNamed:@"btn_88_gray.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
        [_phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_phoneButton];
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
    _phoneButton.frame=CGRectMake(10.f, 10.f, self.width-10*2, 44.f);
}


- (void)phoneButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSGroupInfoPhoneCell: didClickPhoneButton:)])
    {
        [_delegate LSGroupInfoPhoneCell:self didClickPhoneButton:sender];
    }
}

@end
