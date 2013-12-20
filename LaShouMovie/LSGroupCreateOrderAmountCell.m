//
//  LSGroupCreateOrderAmountCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupCreateOrderAmountCell.h"

@implementation LSGroupCreateOrderAmountCell

@synthesize group=_group;
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
        
        _addButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setBackgroundImage:[UIImage lsImageNamed:@"add_red.png"] forState:UIControlStateNormal];
        [_addButton setBackgroundImage:[UIImage lsImageNamed:@"add_red_click.png"] forState:UIControlStateHighlighted];
        [_addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
        
        _amountTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _amountTextField.borderStyle = UITextBorderStyleBezel;
        _amountTextField.userInteractionEnabled = NO;
        _amountTextField.textAlignment = NSTextAlignmentCenter;
        _amountTextField.delegate = self;
        [self addSubview:_amountTextField];
        [_amountTextField release];
        
        _minusButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_minusButton setBackgroundImage:[UIImage lsImageNamed:@"minus_gray.png"] forState:UIControlStateNormal];
        [_minusButton setBackgroundImage:[UIImage lsImageNamed:@"minus_gray.png"] forState:UIControlStateHighlighted];
        [_minusButton addTarget:self action:@selector(minusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_minusButton];
        _minusButton.enabled=NO;
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
    self.textLabel.font=LSFont12;
    self.textLabel.frame=CGRectMake(self.textLabel.left+10, self.textLabel.top, self.textLabel.width, self.textLabel.height);
    self.textLabel.backgroundColor=[UIColor clearColor];
    
    _minusButton.frame=CGRectMake(self.width-20.f-35.f, (self.height-35.f)/2, 35.f, 35.f);
    
    _amount=_amount>0?_amount:_group.minMustBuy;
    _amountTextField.text = [NSString stringWithFormat:@"%d",_amount];
    _amountTextField.frame=CGRectMake(self.width-20.f-35.f-5.f-50.f, (self.height-30.f)/2, 50.f, 30.f);
    
    _addButton.frame=CGRectMake(self.width-20.f-35.f-5.f-50.f-5.f-35.f, (self.height-35.f)/2, 35.f, 35.f);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(contextRef, LSColorLineLightGrayColor.CGColor);
    CGContextSetFillColorWithColor(contextRef, LSColorBgWhiteColor.CGColor);
    
    CGContextSetAllowsAntialiasing(contextRef,true);
    CGContextSetLineWidth(contextRef, 1.f);
	CGRect rrect = CGRectMake((10.f + 1.f / 2), 1.f/2, (300.f-1.f), rect.size.height);
	
	CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(contextRef, minx, midy);
    CGContextAddArcToPoint(contextRef, minx, miny, midx, miny, 0.f);
    CGContextAddArcToPoint(contextRef, maxx, miny, maxx, midy, 0.f);
    CGContextAddArcToPoint(contextRef, maxx, maxy, midx, maxy, 0.f);
    CGContextAddArcToPoint(contextRef, minx, maxy, minx, midy, 0.f);
    CGContextClosePath(contextRef);
	CGContextDrawPath(contextRef, kCGPathFillStroke);
}

#pragma mark- 按钮方法
- (void)addButtonClick:(UIButton*)sender
{
    _amount++;
    _amountTextField.text = [NSString stringWithFormat:@"%d", _amount];
    _minusButton.enabled=YES;
    [_minusButton setBackgroundImage:[UIImage lsImageNamed:@"minus_red.png"] forState:UIControlStateNormal];
    [_minusButton setBackgroundImage:[UIImage lsImageNamed:@"minus_red_click.png"] forState:UIControlStateHighlighted];
    if([_delegate respondsToSelector:@selector(LSGroupCreateOrderAmountCell: didChangeAmount:)])
    {
        [_delegate LSGroupCreateOrderAmountCell:self didChangeAmount:_amount];
    }
}

- (void)minusButtonClick:(UIButton*)sender
{
    _amount--;
    _amountTextField.text = [NSString stringWithFormat:@"%d", _amount];
    if([_delegate respondsToSelector:@selector(LSGroupCreateOrderAmountCell: didChangeAmount:)])
    {
        [_delegate LSGroupCreateOrderAmountCell:self didChangeAmount:_amount];
    }
    
    if(_amount==_group.minMustBuy)
    {
        _minusButton.enabled=NO;
        [_minusButton setBackgroundImage:[UIImage lsImageNamed:@"minus_gray.png"] forState:UIControlStateNormal];
        [_minusButton setBackgroundImage:[UIImage lsImageNamed:@"minus_gray.png"] forState:UIControlStateHighlighted];
    }
}

@end
