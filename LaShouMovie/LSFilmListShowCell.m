//
//  LSFilmListCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFilmListShowCell.h"

#define gap 10.f

@implementation LSFilmListShowCell

@synthesize filmImageView=_filmImageView;
@synthesize film=_film;
@synthesize delegate=_delegate;

#pragma mark- 生命周期
- (void)dealloc
{
    self.film=nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        messageCenter=[LSMessageCenter defaultCenter];
        [messageCenter addObserver:self selector:@selector(filmCellLeftSwiped:) name:LSNotificationFilmCellLeftSwiped object:nil];

        _quickBuyView=[[LSQuickBuyView alloc] initWithFrame:CGRectZero];
        _quickBuyView.delegate=self;
        [self.contentView addSubview:_quickBuyView];
        [_quickBuyView release];
        
        _filmImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_filmImageView];
        [_filmImageView release];

        _starImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _starImageView.clipsToBounds = YES;
        _starImageView.contentMode = UIViewContentModeLeft;
        [self addSubview:_starImageView];
        [_starImageView release];
        
        UISwipeGestureRecognizer* leftSwipeGestureRecognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selfSwipe:)];
        leftSwipeGestureRecognizer.direction=UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:leftSwipeGestureRecognizer];
        [leftSwipeGestureRecognizer release];
        
        UISwipeGestureRecognizer* rightSwipeGestureRecognizer=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(selfSwipe:)];
        rightSwipeGestureRecognizer.direction=UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:rightSwipeGestureRecognizer];
        [rightSwipeGestureRecognizer release];
        
//        UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
//        [self addGestureRecognizer:tapGestureRecognizer];
//        [tapGestureRecognizer release];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
//    self.contentView.clipsToBounds=NO;
    self.contentView.superview.clipsToBounds=NO;
//    self.clipsToBounds=NO;
//    self.superview.clipsToBounds=NO;
    
    _quickBuyView.frame=CGRectMake(320.f, 0.f, 70.f, 90.f);
    
    _filmImageView.frame=CGRectMake(gap, gap, 55.f, 70.f);
    
    //设置点亮的星星
    //50.f=gap+25.f+15.f
    _starImageView.frame=CGRectMake(gap+55.f+gap, 50.f+1.f, 67.f*[_film.grade floatValue]/10, 11.f);
    _starImageView.image = [UIImage imageNamed:@"stars_full.png"];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [_quickBuyView setNeedsDisplay];
    
    CGFloat contentX = gap+55.f+gap;
    CGFloat contentY=gap;
    
    NSString* text=nil;
    
    //图片宽 imax:28  3D:17  预售:35
    //高 14.f
    
    text=_film.filmName;
    CGRect nameRect = [text boundingRectWithSize:CGSizeMake(rect.size.width-contentX-5.f-(_film.isPresell?(35.f+5.f):0.f)-(_film.dimensional==LSFilmDimensional3D?(17.f+5.f):0.f)-(_film.isIMAX?(28.f+5.f):0.f)-gap, INT32_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[LSAttribute attributeFont:LSFontFilmName] context:nil];
    
    [text drawInRect:CGRectMake(contentX, contentY, nameRect.size.width, 25.f) withAttributes:[LSAttribute attributeFont:LSFontFilmName lineBreakMode:NSLineBreakByTruncatingTail]];
    contentX+=(nameRect.size.width+5.f);
    
    //绘制imax
    if(_film.isIMAX)
    {
        [[UIImage lsImageNamed:@"icon_imax.png"] drawInRect:CGRectMake(contentX, contentY+3.f, 28.f, 14.f)];
        contentX+=28.f+5.f;
    }
    
    //绘制dimensional
    if(_film.dimensional==LSFilmDimensional3D)
    {
        [[UIImage lsImageNamed:@"icon_3d.png"] drawInRect:CGRectMake(contentX, contentY+3.f, 17.f, 14.f)];
        contentX+=17.f+5.f;
    }
    
    //绘制是否预售
    if(_film.isPresell)
    {
        [[UIImage lsImageNamed:@"icon_presell.png"] drawInRect:CGRectMake(contentX, contentY+3.f, 35.f, 14.f)];
        contentX+=35.f;
    }
    
    contentX = gap+55.f+gap;
    contentY += 25.f;

    text=_film.brief;
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width-contentX-20.f-gap, 15.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorTextGray lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=15.f;
    
    //绘制星级
    [[UIImage lsImageNamed:@"stars_empty.png"] drawInRect:CGRectMake(contentX, contentY+1.f, 67.f, 11.f)];

    contentY+=1.f;
    text = [NSString stringWithFormat:@"%@分", _film.grade];
    [text drawInRect:CGRectMake(contentX+67.f+5.f, contentY, rect.size.width, 15.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorTextRed lineBreakMode:NSLineBreakByTruncatingTail]];
    
    contentY+=15.f;

    //绘制上映信息
    if(_film.showCinemasCount>0 && _film.showSchedulesCount>0)
    {
        text=[NSString stringWithFormat:@"%d家影院上映%d场", _film.showCinemasCount, _film.showSchedulesCount];
    }
    else
    {
        text=@"没有上映影院";
    }
    [text drawInRect:CGRectMake(contentX, contentY, rect.size.width, 15.f) withAttributes:[LSAttribute attributeFont:LSFontFilmInfo color:LSColorTextGray lineBreakMode:NSLineBreakByTruncatingTail]];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    //LSLog(@"%f %f ",point.x,point.y);
    
    if(!_isUseHitTest)
    {
        return [super hitTest:point withEvent:event];
    }
    
    if(self.left<0 && point.x>250.f)
    {
        return _quickBuyView;
    }
    else
    {
        return [super hitTest:point withEvent:event];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark- 私有方法
- (void)selfSwipe:(UISwipeGestureRecognizer*)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        _isUseHitTest=YES;
        //发送消息
        [[LSMessageCenter defaultCenter] postNotificationName:LSNotificationFilmCellLeftSwiped object:self];
        
        [UIView animateWithDuration:0.2 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.frame=CGRectMake(-70.f, self.top, self.width, self.height);
        } completion:^(BOOL finished) { }];
    }
    else if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        _isUseHitTest=NO;
        [UIView animateWithDuration:0.2 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.frame=CGRectMake(0.f, self.top, self.width, self.height);
        } completion:^(BOOL finished) { }];
    }
}

#pragma mark- 通知方法
- (void)filmCellLeftSwiped:(NSNotification*)notification
{
    if(![notification.object isEqual:self])
    {
        [UIView animateWithDuration:0.2 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            self.frame=CGRectMake(0.f, self.top, self.width, self.height);
        } completion:^(BOOL finished) { }];
    }
}

#pragma mark- LSQuickBuyView的委托方法
- (void)LSQuickBuyViewDidClick:(LSQuickBuyView *)quickBuyView
{
    [_delegate LSFilmListShowCell:self didClickQuickBuyView:quickBuyView];
}

@end
