//
//  LSWelcomeView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSWelcomeView.h"

@implementation LSWelcomeView

@synthesize delegate=_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.width, HeightOfiPhoneX(460.f))];
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.contentSize=CGSizeMake(_scrollView.width*3, _scrollView.height);
        _scrollView.pagingEnabled=YES;
        _scrollView.bounces=NO;
        _scrollView.backgroundColor=[UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        [self addSubview:_scrollView];
        [_scrollView release];
        
        for(int i=1;i<=3;i++)
        {
            UIImageView* imageView=[[UIImageView alloc] initWithImage:[UIImage lsImageNamed:[NSString stringWithFormat:@"guide%d.png",i] is568:(ScreenHeight==568)]];
            imageView.contentMode=UIViewContentModeScaleAspectFit;
            imageView.frame=CGRectMake((i-1)*_scrollView.width, 0.f, _scrollView.width, _scrollView.height);
            [_scrollView addSubview:imageView];
            [imageView release];
        }
        
        UIButton* intoButton=[UIButton buttonWithType:UIButtonTypeCustom];
        intoButton.frame=CGRectMake(2*_scrollView.width+80.f, _scrollView.height-70.f, _scrollView.width-80.f*2, 40.f);
        [intoButton addTarget:self action:@selector(intoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:intoButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark- 私有方法
- (void)intoButtonClick:(UIButton*)sender
{
    if([_delegate respondsToSelector:@selector(LSWelcomeViewDidWelcome)])
    {
        [_delegate LSWelcomeViewDidWelcome];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        
        self.alpha=0.f;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

@end
