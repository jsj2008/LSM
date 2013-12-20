//
//  LSAnnotationView.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAnnotationView.h"
#import "LSAnnotation.h"

@implementation LSAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
	if (self != nil)
    {
#warning 自定义MKAnnotationView，绝对不能设置clipsToBounds = YES，否则冲突会导致不可预知错误
        self.canShowCallout=YES;
        self.backgroundColor = [UIColor clearColor];
    }
	
	return self;
}

- (void)setAnnotation:(id <MKAnnotation>)annotation
{
    [super setAnnotation:annotation];
	
    CGSize size = CGSizeMake(20, 25);
    self.frame = CGRectMake((self.center.x - size.width / 2), (self.center.y - size.height / 2), size.width, size.height);
}

- (void)layoutSubviews
{
	[super layoutSubviews];
//    self.layer.anchorPoint = CGPointMake(0.5, 1);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    LSAnnotation* annotation=self.annotation;
    
    if (self.isSelected)
    {
        if (annotation.cinema.buyType == LSCinemaBuyTypeOnlySeat)
        {
            [[UIImage lsImageNamed:@"ticketOrange.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else if (annotation.cinema.buyType == LSCinemaBuyTypeOnlyGroup)
        {
            [[UIImage lsImageNamed:@"groupeOrange.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else if (annotation.cinema.buyType == LSCinemaBuyTypeSeatGroup)
        {
            [[UIImage lsImageNamed:@"TGOrange.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else if (annotation.cinema.buyType == LSCinemaBuyTypeNon)
        {
            [[UIImage lsImageNamed:@"map_an_h.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else
        {
            
        }
    }
    else
    {
        if (annotation.cinema.buyType == LSCinemaBuyTypeOnlySeat)
        {
            [[UIImage lsImageNamed:@"ticketBlue.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else if (annotation.cinema.buyType == LSCinemaBuyTypeOnlyGroup)
        {
            [[UIImage lsImageNamed:@"groupeBlue.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else if (annotation.cinema.buyType == LSCinemaBuyTypeSeatGroup)
        {
            [[UIImage lsImageNamed:@"TGBlue.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else if (annotation.cinema.buyType == LSCinemaBuyTypeNon)
        {
            [[UIImage lsImageNamed:@"map_an_n.png"] drawInRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
        else
        {
            
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self setNeedsDisplay];
}

@end
