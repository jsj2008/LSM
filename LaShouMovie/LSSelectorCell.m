//
//  LSSelectorCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSSelectorCell.h"

@implementation LSSelectorCell

@synthesize isInitial=_isInitial;
@synthesize type=_type;
@synthesize infoLabel=_infoLabel;

#pragma mark- 属性方法
- (void)setIsInitial:(BOOL)isInitial
{
    _isInitial=isInitial;
    if (_type == LSSelectorViewTypeLocation)
    {
        if(_isInitial)
        {
            _infoLabel.textColor = [UIColor blackColor];
        }
        else
        {
            _infoLabel.textColor = [UIColor whiteColor];
        }
    }
    else if (_type == LSSelectorViewTypeSection)
    {
        if(!_isInitial)
        {
            _infoLabel.textColor = [UIColor blackColor];
        }
        else
        {
            _infoLabel.textColor = [UIColor redColor];
        }
    }
}


#pragma mark- 生命周期
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoLabel.backgroundColor = [UIColor clearColor];
        _infoLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_infoLabel];
        [_infoLabel release];
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
    
    _infoLabel.frame = CGRectMake(10.f, 0.f, self.frame.size.width-20.f, self.frame.size.height);
    if (_type == LSSelectorViewTypeLocation)
    {
        _infoLabel.font = LSFont13;
        _infoLabel.textAlignment = UITextAlignmentLeft;
    }
    else if (_type == LSSelectorViewTypeSection)
    {
        _infoLabel.font = LSFont15;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (void)drawRect:(CGRect)rect
{
    if (_type == LSSelectorViewTypeLocation)
    {
        [self drawLineAtStartPointX:0 y:rect.size.height-2 endPointX:rect.size.width y:rect.size.height-2 strokeColor:LSRGBA(9, 8, 9, 1.f) lineWidth:0.5f];
        [self drawLineAtStartPointX:0 y:rect.size.height-1 endPointX:rect.size.width y:rect.size.height-1 strokeColor:LSRGBA(81, 81, 82, 1.f) lineWidth:0.5f];
        
        if (_isInitial)
        {
            [self drawRoundRectangleInRect:CGRectMake(0, 0, rect.size.width-2, rect.size.height-2) topRadius:3.f bottomRadius:3.f isBottomLine:NO fillColor:LSColorBgGrayColor strokeColor:LSColorBgGrayColor borderWidth:0.f];
        }
    }
    else if (_type == LSSelectorViewTypeSection)
    {
        [self drawLineAtStartPointX:0 y:rect.size.height-1 endPointX:rect.size.width y:rect.size.height-1 strokeColor:[UIColor whiteColor] lineWidth:1.f];
        if (_isInitial)
        {
            [self drawRoundRectangleInRect:CGRectMake(1.f, 1.f, rect.size.width-2.f, rect.size.height-2.f) topRadius:3.f bottomRadius:3.f isBottomLine:NO fillColor:[UIColor lightGrayColor] strokeColor:[UIColor lightGrayColor] borderWidth:0.f];
        }
    }
}

@end
