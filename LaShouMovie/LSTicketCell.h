//
//  LSTicketCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSTicket.h"

@interface LSTicketCell : LSTableViewCell
{
    LSTicket* _ticket;
}
@property(nonatomic,retain) LSTicket* ticket;

@end
