//
//  LSPaidOrderCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@protocol LSPaidOrderCellDelegate;
@interface LSPaidOrderCell : LSTableViewCell
{
    UIButton* _mapButton;
    UIButton* _phoneButton;
    
    LSOrder* _order;
    id<LSPaidOrderCellDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSPaidOrderCellDelegate> delegate;

+ (CGFloat)heightOfOrder:(LSOrder*)order;

@end

@protocol LSPaidOrderCellDelegate <NSObject>

- (void)LSPaidOrderCell:(LSPaidOrderCell*)paidOrderCell didClickMapButtonForOrder:(LSOrder*)order;
- (void)LSPaidOrderCell:(LSPaidOrderCell*)paidOrderCell didClickPhoneButtonForOrder:(LSOrder*)order;

@end
