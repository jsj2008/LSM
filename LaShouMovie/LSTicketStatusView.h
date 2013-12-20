//
//  LSTicketStatusView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSTicketStatusViewDelegate;
@interface LSTicketStatusView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    LSTicketStatus _status;//选项
    NSArray* _statusArray;//影院状态数组
    UITableView* _tableView;
    
    id<LSTicketStatusViewDelegate> _delegate;
}
@property(nonatomic,assign) LSTicketStatus status;
@property(nonatomic,assign) id<LSTicketStatusViewDelegate> delegate;

@end

@protocol LSTicketStatusViewDelegate <NSObject>

- (void)LSTicketStatusView:(LSTicketStatusView*)ticketStatusView didSelectRowAtIndexPath:(LSTicketStatus)status;

@end
