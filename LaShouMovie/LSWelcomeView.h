//
//  LSWelcomeView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-22.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSWelcomeViewDelegate;
@interface LSWelcomeView : UIView
{
    UIScrollView* _scrollView;
    id<LSWelcomeViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSWelcomeViewDelegate> delegate;

@end

@protocol LSWelcomeViewDelegate <NSObject>

- (void)LSWelcomeViewDidWelcome;

@end
