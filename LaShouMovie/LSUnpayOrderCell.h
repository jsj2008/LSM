//
//  LSUnpayOrderCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-2.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"
#import "LSSimpleCountDownView.h"

@protocol LSUnpayOrderCellDelegate;
@interface LSUnpayOrderCell : LSTableViewCell<LSSimpleCountDownViewDelegate>
{
    UIButton* _mapButton;
    UIButton* _phoneButton;
    UIButton* _payButton;
    LSSimpleCountDownView* _simpleCountDownView;
    
    LSOrder* _order;
    id<LSUnpayOrderCellDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSUnpayOrderCellDelegate> delegate;

+ (CGFloat)heightOfOrder:(LSOrder*)order;

@end

@protocol LSUnpayOrderCellDelegate <NSObject>

- (void)LSUnpayOrderCell:(LSUnpayOrderCell*)unpayOrderCell didClickMapButtonForOrder:(LSOrder*)order;
- (void)LSUnpayOrderCell:(LSUnpayOrderCell*)unpayOrderCell didClickPhoneButtonForOrder:(LSOrder*)order;
- (void)LSUnpayOrderCell:(LSUnpayOrderCell*)unpayOrderCell didClickPayButtonForOrder:(LSOrder*)order;
- (void)LSUnpayOrderCell:(LSUnpayOrderCell*)unpayOrderCell didTimeoutForOrder:(LSOrder*)order;

@end
