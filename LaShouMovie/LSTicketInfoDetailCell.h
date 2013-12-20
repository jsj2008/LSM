//
//  LSTicketInfoDetailCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSTicket.h"

@interface LSTicketInfoDetailCell : LSTableViewCell
{
    LSTicket* _ticket;
}
@property(nonatomic,retain) LSTicket* ticket;

//+ (CGFloat)heightOfTicket;

@end
