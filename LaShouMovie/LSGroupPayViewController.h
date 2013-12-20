//
//  LSGroupInfoViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSGroupOrder.h"
#import "LSGroupPaySectionFooter.h"
#import "LSGroupWebPayViewController.h"

@protocol LSGroupPayViewControllerDelegate;
@interface LSGroupPayViewController : LSTableViewController<UITableViewDataSource,UITableViewDelegate,LSGroupPaySectionFooterDelegate,LSGroupWebPayViewControllerDelegate>
{
    LSGroupOrder* _groupOrder;
    UITableView* _tableView;
    id<LSGroupPayViewControllerDelegate> _delegate;
}
@property(nonatomic,retain) LSGroupOrder* groupOrder;
@property(nonatomic,assign) id<LSGroupPayViewControllerDelegate> delegate;

@end

@protocol LSGroupPayViewControllerDelegate <NSObject>

- (void)LSGroupPayViewControllerDidPay;
- (void)LSGroupPayViewControllerDidCancel;

@end
