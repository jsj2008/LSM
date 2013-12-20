//
//  LSCountDownView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-26.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSCountDownViewDelegate;
@interface LSCountDownView : UIView
{
    BOOL _timeout;
    NSTimer* _timer;
    
    NSInteger _minute;
    NSInteger _second;
    
    id<LSCountDownViewDelegate> _delegate;
}

@property(nonatomic,assign) NSInteger minute;
@property(nonatomic,assign) NSInteger second;
@property(nonatomic,assign) id<LSCountDownViewDelegate> delegate;

- (void)startCountDown;
- (void)stopCountDown;

@end

@protocol LSCountDownViewDelegate <NSObject>

- (void)LSCountDownViewDidTimeout;

@end
