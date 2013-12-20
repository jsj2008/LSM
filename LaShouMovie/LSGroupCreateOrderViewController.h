//
//  LSGroupCreateOrderViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSGroup.h"
#import "LSGroupOrder.h"
#import "LSGroupCreateOrderSectionFooter.h"
#import "LSGroupPayViewController.h"
#import "LSGroupCreateOrderAmountCell.h"
#import "LSGroupCreateOrderMobileCell.h"
#import "LSBindViewController.h"

@protocol LSGroupCreateOrderViewControllerDelegate;
@interface LSGroupCreateOrderViewController : LSTableViewController
<
LSGroupCreateOrderSectionFooterDelegate,
LSGroupPayViewControllerDelegate,
LSGroupCreateOrderAmountCellDelegate,
LSGroupCreateOrderMobileCellDelegate,
LSBindViewControllerDelegate,
UIAlertViewDelegate
>
{
    LSGroup* _group;
    NSInteger _amount;
    id<LSGroupCreateOrderViewControllerDelegate> _delegate;
    NSString* _maybeOrderID;
}
@property(nonatomic,retain) LSGroup* group;
@property(nonatomic,assign) id<LSGroupCreateOrderViewControllerDelegate> delegate;

@end

@protocol LSGroupCreateOrderViewControllerDelegate <NSObject>

- (void)LSGroupCreateOrderViewControllerDidCreateOrder;

@end
