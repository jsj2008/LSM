//
//  LSTicketInfoInfoCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSTicket.h"

@interface LSTicketInfoInfoCell : LSTableViewCell
{
    LSTicket* _ticket;
}
@property(nonatomic,retain) LSTicket* ticket;

+ (CGFloat)heightOfTicket:(LSTicket*)ticket;

@end
