//
//  LSStillCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSStillCell.h"

@implementation LSStillCell

@synthesize bigStillURL=_bigStillURL;
@synthesize stillURL=_stillURL;

#pragma mark- 属性方法
- (void)setBigStillURL:(NSString *)bigStillURL
{
    if(![_bigStillURL isEqual:bigStillURL])
    {
        if(_bigStillURL!=nil)
        {
            LSRELEASE(_bigStillURL)
        }
        _bigStillURL=[bigStillURL retain];
        [_stillImageView setImageWithURL:[NSURL URLWithString:_bigStillURL] placeholderImage:[[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_stillURL]]]];
    }
}

#pragma mark- 生命周期
- (void)dealloc
{
    self.bigStillURL=nil;
    self.stillURL=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _scrollView=[[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _scrollView.minimumZoomScale=1.f;
        _scrollView.maximumZoomScale=2.f;
        _scrollView.bounces=NO;
        _scrollView.showsHorizontalScrollIndicator=NO;
        _scrollView.showsVerticalScrollIndicator=NO;
        _scrollView.delegate=self;
        [self addSubview:_scrollView];
        [_scrollView release];
        
        _stillImageView=[[UIImageView alloc] initWithFrame:CGRectZero];
        _stillImageView.userInteractionEnabled=YES;
//        _stillImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _stillImageView.contentMode=UIViewContentModeScaleAspectFit;
        [_scrollView addSubview:_stillImageView];
        [_stillImageView release];
        
        UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [_stillImageView addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
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
    
    _scrollView.frame=CGRectMake(0.f, 0.f, self.height, self.width);
    _stillImageView.frame=_scrollView.frame;
    
    [_scrollView setZoomScale:1.f];
}

- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    if(_scrollView.zoomScale>1.f)
    {
        [_scrollView setZoomScale:1.f animated:YES];
    }
}

#pragma mark- UIScrollView的委托方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _stillImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    if (scale <= 1.f)
    {
        scrollView.scrollEnabled = NO;
    }
    else
    {
        scrollView.scrollEnabled = YES;
    }
}

@end
