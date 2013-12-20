//
//  LSSeatView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSeat.h"

@protocol LSSeatViewDelegate;
@interface LSSeatView : UIView
{
    LSSeat* _seat;
    id<LSSeatViewDelegate> _delegate;
}

@property(nonatomic,retain) LSSeat* seat;
@property(nonatomic,assign) id<LSSeatViewDelegate> delegate;

@end

@protocol LSSeatViewDelegate <NSObject>

@required
- (void)LSSeatView:(LSSeatView*)seatView didSelectAtSeat:(LSSeat*)seat;

@end
