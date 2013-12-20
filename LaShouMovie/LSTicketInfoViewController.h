//
//  LSTicketInfoViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSTicket.h"
#import "LSTicketInfoWebCell.h"

@interface LSTicketInfoViewController : LSTableViewController<LSTicketInfoWebCellDelegate>
{
    LSTicket* _ticket;
    CGFloat _webHeight;
}
@property(nonatomic,retain) LSTicket* ticket;

@end
