//
//  LSGroupCreateOrderMobileCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupCreateOrderMobileCell.h"
#define gapL 20

@implementation LSGroupCreateOrderMobileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _bindButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _bindButton.titleLabel.font = LSFontBold13;
        [_bindButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bindButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_bind.png"] top:14 left:5 bottom:14 right:5] forState:UIControlStateNormal];
        [_bindButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_bind_d.png"] top:14 left:5 bottom:14 right:5] forState:UIControlStateHighlighted];
        [_bindButton addTarget:self action:@selector(bindButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bindButton];
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
    _bindButton.frame = CGRectMake(self.width-gapL-58.f, (self.height-10.f-28.f)/2+10.f, 58.f, 28.f);
}

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect=CGRectMake(10, 10, rect.size.width-2*10, rect.size.height-10);

    LSUser* user=[LSUser currentUser];
    
    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text=nil;
    if(user.mobile!=nil && ![user.mobile isEqualToString:LSNULL])
    {
        text=[NSString stringWithFormat:@"绑定手机号: %@",user.mobile];
        [_bindButton setTitle:@"更换" forState:UIControlStateNormal];
    }
    else
    {
        text=@"未绑定手机号";
        [_bindButton setTitle:@"绑定" forState:UIControlStateNormal];
    }
    CGSize size=[text sizeWithFont:LSFont13];
    CGFloat height=(rect.size.height-10.f-size.height)/2+10.f;
    [text drawInRect:CGRectMake(gapL, height, size.width, 16) withFont:LSFont13];
}

- (void)bindButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSGroupCreateOrderMobileCellDidSelect)])
    {
        [_delegate LSGroupCreateOrderMobileCellDidSelect];
    }
}

@end
