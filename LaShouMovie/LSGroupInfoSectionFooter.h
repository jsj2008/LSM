//
//  LSGroupInfoSectionFooter.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSGroup.h"

@protocol LSGroupInfoSectionFooterDelegate;
@interface LSGroupInfoSectionFooter : UIView
{
    LSGroup* _group;
    UIButton* _buyButton;
    id<LSGroupInfoSectionFooterDelegate> _delegate;
}
@property(nonatomic,retain) LSGroup* group;
@property(nonatomic,assign) id<LSGroupInfoSectionFooterDelegate> delegate;

@end

@protocol LSGroupInfoSectionFooterDelegate <NSObject>

- (void)LSGroupInfoSectionFooter:(LSGroupInfoSectionFooter*)groupInfoSectionFooter didClickBuyButton:(UIButton*)buyButton;

@end
