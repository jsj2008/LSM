//
//  LSSimpleCountDownView.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-3.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSSimpleCountDownViewDelegate;
@interface LSSimpleCountDownView : UIView
{
    BOOL _timeout;
    NSTimer* _timer;
    
    NSInteger _minute;
    NSInteger _second;
    
    id<LSSimpleCountDownViewDelegate> _delegate;
}

@property(nonatomic,assign) NSInteger minute;
@property(nonatomic,assign) NSInteger second;
@property(nonatomic,assign) id<LSSimpleCountDownViewDelegate> delegate;

- (void)startCountDown;
- (void)stopCountDown;

@end

@protocol LSSimpleCountDownViewDelegate <NSObject>

- (void)LSSimpleCountDownViewDidTimeout;

@end
