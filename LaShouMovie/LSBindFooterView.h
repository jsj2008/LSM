//
//  LSBindFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSBindFooterViewDelegate;
@interface LSBindFooterView : UIView
{
    UIButton* _bindButton;
    id<LSBindFooterViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSBindFooterViewDelegate> delegate;

@end

@protocol LSBindFooterViewDelegate <NSObject>

@required
- (void)LSBindFooterView:(LSBindFooterView*)bindFooterView didClickBindButton:(UIButton*)bindButton;

@end
