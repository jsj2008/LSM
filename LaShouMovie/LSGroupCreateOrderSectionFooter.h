//
//  LSGroupCreateOrderSectionFooter.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSGroupCreateOrderSectionFooterDelegate;
@interface LSGroupCreateOrderSectionFooter : UIView
{
    UIButton* _submitButton;
    id<LSGroupCreateOrderSectionFooterDelegate> _delegate;
}
@property(nonatomic,assign) id<LSGroupCreateOrderSectionFooterDelegate> delegate;

@end

@protocol LSGroupCreateOrderSectionFooterDelegate <NSObject>

- (void)LSGroupCreateOrderSectionFooter:(LSGroupCreateOrderSectionFooter*)groupCreateOrderSectionFooter didClickSubmitButton:(UIButton*)submitButton;

@end
