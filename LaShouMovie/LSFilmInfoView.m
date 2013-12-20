//
//  LSFilmInfoView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-13.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmInfoView.h"
#define gapL 0

@implementation LSFilmInfoView

@synthesize film=_film;
@synthesize delegate=_delegate;

#pragma mark- 生命周期

- (void)dealloc
{
    self.film=nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
        [self addGestureRecognizer:tapGestureRecognizer];
        [tapGestureRecognizer release];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"cinema_info_film_bg.png"] top:20 left:7 bottom:20 right:7] drawInRect:CGRectMake(0, 6, rect.size.width, (rect.size.height - 7))];
    [[UIImage lsImageNamed:@"cinema_info_film_arrow.png"] drawInRect:CGRectMake((rect.size.width - 12)/2, 0, 12, 7)];
    
    if(!_film)
        return;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGFloat contentX = gapL;
    
    if (_film.filmName)
    {
        CGContextSetFillColorWithColor(contextRef, [[UIColor blackColor] CGColor]);
        CGSize size = [_film.filmName sizeWithFont:LSFont18];
        [_film.filmName drawInRect:CGRectMake(10.f, 16.f, size.width, size.height) withFont:LSFont18];
        
        contentX+=size.width;
    }

    if (_film.grade)
    {
        CGContextSetFillColorWithColor(contextRef, [[UIColor orangeColor] CGColor]);
        NSString* text=[NSString stringWithFormat:@"%@分", _film.grade];
        CGSize size = [text sizeWithFont:LSFont16];
        [text drawInRect:CGRectMake(20.f+contentX, 18.f, size.width, size.height) withFont:LSFont16];
    }
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(self.width-20.f, self.height/2, 10.f, 15.f)];
}


#pragma mark- 点击方法
- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    if([_delegate respondsToSelector:@selector(LSFilmInfoView: didClickForFilm:)])
    {
        [_delegate LSFilmInfoView:self didClickForFilm:_film];
    }
}

@end
