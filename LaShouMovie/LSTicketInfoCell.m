//
//  LSTicketInfoCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketInfoCell.h"

#define gapL 20.f
#define basicWidth 260.f
#define basicSize CGSizeMake(basicWidth, INT32_MAX)

@implementation LSTicketInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect
{
    CGRect bgRect=CGRectMake(10.f, 10.f, rect.size.width-2*10.f, rect.size.height-10.f);
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(contextRef, [UIColor blackColor].CGColor);
    
    NSString* text=@"重新获取拉手券密码(短信)";
    CGSize size=[text sizeWithFont:LSFont15];
    [text drawInRect:CGRectMake(gapL, (rect.size.height-10.f-size.height)/2+10.f, size.width, size.height) withFont:LSFont15];
    
    [[UIImage lsImageNamed:@"cinemas_arrow.png"] drawInRect:CGRectMake(rect.size.width - 30.f, (rect.size.height-10.f-15.f)/2+10.f, 10.f, 15.f)];
}

@end
