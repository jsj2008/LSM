//
//  LSGroupInfoNeedPayCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSGroupPayNeedPayCell : LSTableViewCell
{
    CGFloat _topRadius;
    CGFloat _bottomRadius;
    BOOL _isBottomLine;
    
    NSString* _needPay;
}
@property(nonatomic,assign) CGFloat topRadius;
@property(nonatomic,assign) CGFloat bottomRadius;
@property(nonatomic,assign) BOOL isBottomLine;
@property(nonatomic,retain) NSString* needPay;

@end
