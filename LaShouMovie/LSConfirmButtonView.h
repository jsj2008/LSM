//
//  LSConfirmButtonView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-24.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSConfirmButtonViewDelegate;
@interface LSConfirmButtonView : UIView
{
    NSString* _price;
    id<LSConfirmButtonViewDelegate> _delegate;
}
@property(nonatomic,retain) NSString* price;
@property(nonatomic,assign) id<LSConfirmButtonViewDelegate> delegate;

@end

@protocol LSConfirmButtonViewDelegate <NSObject>

@required
- (void)LSConfirmButtonViewDidClick;

@end
