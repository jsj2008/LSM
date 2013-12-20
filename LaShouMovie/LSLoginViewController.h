//
//  LSLoginViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"

#import "LSRegisterViewController.h"
#import "LSSinaWBAuthViewController.h"
#import "LSQQWBAuthViewController.h"
#import "LSQQAuthViewController.h"
#import "LSLoginCell.h"
#import "LSLoginFooterView.h"
#import "LSUnionLoginView.h"

@protocol LSLoginViewControllerDelegate;
@interface LSLoginViewController : LSTableViewController<LSLoginFooterViewDelegate,LSUnionLoginViewDelegate,LSRegisterViewControllerDelegate,LSSinaWBAuthViewControllerDelegate,LSQQWBAuthViewControllerDelegate,LSQQAuthViewControllerDelegate>
{
    LSLoginCell* _nameCell;
    LSLoginCell* _passwordCell;
    
    id<LSLoginViewControllerDelegate> _delegate;
}
@property(nonatomic,assign) id<LSLoginViewControllerDelegate> delegate;

@end

@protocol LSLoginViewControllerDelegate <NSObject>

@required
- (void)LSLoginViewControllerDidLoginByType:(LSLoginType)loginType;

@end
