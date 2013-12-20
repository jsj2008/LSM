//
//  LSSeatSectionFooter.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-9-14.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSSeatSectionFooterDelegate;
@interface LSSeatSectionFooter : UIView
{
    UIButton* _button;
    id<LSSeatSectionFooterDelegate> _delegate;
}
@property(nonatomic,assign) id<LSSeatSectionFooterDelegate> delegate;

@end

@protocol LSSeatSectionFooterDelegate <NSObject>

- (void)LSSeatSectionFooter:(LSSeatSectionFooter*)seatSectionFooter didClickButton:(UIButton*)button;

@end
