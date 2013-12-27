//
//  LSPayFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSPayFooterViewDelegate;
@interface LSPayFooterView : UIView
{
    UIButton* _payButton;
    NSString* _title;
    id<LSPayFooterViewDelegate> _delegate;
}
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) id<LSPayFooterViewDelegate> delegate;

@end

@protocol LSPayFooterViewDelegate <NSObject>

@required
- (void)LSPayFooterView:(LSPayFooterView*)payFooterView didClickPayButton:(UIButton*)payButton;

@end
