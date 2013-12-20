//
//  LSMyMobileCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSMyMobileCell.h"
#define gapL 20.f

@implementation LSMyMobileCell

@synthesize delegate=_delegate;

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
    _bindButton.frame = CGRectMake(self.width-gapL-58.f, (self.height-10.f-28)/2+10.f, 58.f, 28.f);
}

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect=CGRectMake(10, 10, rect.size.width-2*10, rect.size.height-10);
    [self drawRoundRectangleInRect:bgRect topRadius:3.f bottomRadius:3.f isBottomLine:NO fillColor:LSColorBgWhiteColor strokeColor:LSColorLineLightGrayColor borderWidth:0.5f];
    
    LSUser* user=[LSUser currentUser];

    CGContextRef contextRef=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    NSString* text=nil;
    if(user.mobile!=nil && ![user.mobile isEqualToString:LSNULL])
    {
        NSMutableString* mobile=[NSMutableString stringWithString:user.mobile];
        [mobile replaceCharactersInRange:NSMakeRange(3, user.mobile.length-7) withString:@"****"];
        text=[NSString stringWithFormat:@"绑定手机号: %@",mobile];
        [_bindButton setTitle:@"更换" forState:UIControlStateNormal];
    }
    else
    {
        text=@"未绑定手机号";
        [_bindButton setTitle:@"绑定" forState:UIControlStateNormal];
    }
    CGSize size=[text sizeWithFont:LSFont15];
    CGFloat height=(rect.size.height-10.f-size.height)/2+10.f;
    [text drawInRect:CGRectMake(gapL, height, size.width, size.height) withFont:LSFont15];
}

- (void)bindButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSMyMobileCellDidSelect)])
    {
        [_delegate LSMyMobileCellDidSelect];
    }
}

@end
