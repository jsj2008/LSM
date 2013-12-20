//
//  LSSeatsInfoView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSOrder.h"

@protocol LSSeatsInfoViewDelegate;
@interface LSSeatsInfoView : UIView
{
    UIButton* _confirmButton;
    UIButton* _sectionButton;
    LSOrder* _order;
    
    id<LSSeatsInfoViewDelegate> _delegate;
}
@property(nonatomic,retain) LSOrder* order;
@property(nonatomic,assign) id<LSSeatsInfoViewDelegate> delegate;

@end

@protocol LSSeatsInfoViewDelegate <NSObject>

- (void)LSSeatsInfoView:(LSSeatsInfoView*)seatsInfoView didClickSectionButton:(UIButton*)sectionButton;
- (void)LSSeatsInfoView:(LSSeatsInfoView*)seatsInfoView didClickConfirmButton:(UIButton*)confirmButton;
@end
