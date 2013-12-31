//
//  LSTicketInfoWebCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@protocol LSTicketInfoWebCellDelegate;
@interface LSTicketInfoWebCell : LSTableViewCell<UIWebViewDelegate>
{
    UIWebView* _tipsWebView;
    NSString* _html;
    id<LSTicketInfoWebCellDelegate> _delegate;
}
@property(nonatomic,retain) NSString* html;
@property(nonatomic,assign) id<LSTicketInfoWebCellDelegate> delegate;

@end

@protocol LSTicketInfoWebCellDelegate <NSObject>

- (void)LSTicketInfoWebCellDidLoadHTMLContentHeight:(CGFloat)height;

@end
