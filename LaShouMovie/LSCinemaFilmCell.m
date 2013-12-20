//
//  LSCinemaFilmCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-13.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaFilmCell.h"

@implementation LSCinemaFilmCell

@synthesize filmImageView=_filmImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=NO;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        CGRect rect=UIEdgeInsetsInsetRect(self.contentView.frame, UIEdgeInsetsMake(3, 3, 3, 3));
        _filmImageView=[[UIImageView alloc] init];
        _filmImageView.frame=rect;
        _filmImageView.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_filmImageView];
        [_filmImageView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
