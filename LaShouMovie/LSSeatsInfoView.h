//
//  LSSeatsInfoView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSConfirmButtonView.h"
#import "LSOrder.h"

@protocol LSSeatsInfoViewDelegate;
@interface LSSeatsInfoView : UIView<LSConfirmButtonViewDelegate>
{
    LSOrder* _order;
    id<LSSeatsInfoViewDelegate> _delegate;
    LSConfirmButtonView* _confirmButtonView;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSSeatsInfoViewDelegate> delegate;

@end

@protocol LSSeatsInfoViewDelegate <NSObject>

@required
- (void)LSSeatsInfoView:(LSSeatsInfoView*)seatsInfoView didClickConfirmButtonView:(LSConfirmButtonView*)confirmButtonView;

@end
