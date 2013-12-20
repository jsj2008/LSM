//
//  LSAdView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAdView.h"

#import "LSAdvertisment.h"

#define timerInterval 3.0

@implementation LSAdView

@synthesize delegate=_delegate;
@synthesize advertisment=_advertisment;

#pragma mark- 生命周期
- (void)dealloc
{
    self.advertisment=nil;
    [super dealloc];
}

//高度50
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _adImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        _adImageView.userInteractionEnabled=YES;
        [self addSubview:_adImageView];
        [_adImageView release];

        UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [_adImageView addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
        
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(320.f-50.f, 0, 50.f, 50.f);
        [closeButton setImage:[UIImage lsImageNamed:@""] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeButton];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _adImageView.frame=CGRectMake(0.f, 0.f, self.width, self.height);
    [_adImageView setImageWithURL:[NSURL URLWithString:_advertisment.imageURL] placeholderImage:LSPlaceholderImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark- 按钮单击方法
- (void)closeButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSAdViewDidClose)])
    {
        [_delegate LSAdViewDidClose];
    }
}
- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    if([_delegate respondsToSelector:@selector(LSAdViewDidSelect)])
    {
        [_delegate LSAdViewDidSelect];
    }
}

@end
