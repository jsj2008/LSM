//
//  LSGroupInfoSectionFooter.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSGroupPaySectionFooterDelegate;
@interface LSGroupPaySectionFooter : UIView
{
    UIButton* _cancelButton;
    UIButton* _payButton;
    id<LSGroupPaySectionFooterDelegate> _delegate;
}
@property(nonatomic,assign) id<LSGroupPaySectionFooterDelegate> delegate;

@end

@protocol LSGroupPaySectionFooterDelegate <NSObject>

- (void)LSGroupPaySectionFooter:(LSGroupPaySectionFooter*)groupPaySectionFooter didClickCancelButton:(UIButton*)cancelButton;
- (void)LSGroupPaySectionFooter:(LSGroupPaySectionFooter*)groupPaySectionFooter didClickPayButton:(UIButton*)payButton;

@end
