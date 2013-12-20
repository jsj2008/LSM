//
//  LSRegisterViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"
#import "LSBindViewController.h"
#import "LSRegisterCell.h"
#import "LSRegisterFooterView.h"

@protocol LSRegisterViewControllerDelegate;
@interface LSRegisterViewController : LSTableViewController<LSRegisterFooterViewDelegate,LSBindViewControllerDelegate>
{
    LSRegisterCell* _emailCell;
    LSRegisterCell* _nameCell;
    LSRegisterCell* _passwordCell;
    
    id<LSRegisterViewControllerDelegate> _delegate;
}
@property(nonatomic,assign) id<LSRegisterViewControllerDelegate> delegate;

@end

@protocol LSRegisterViewControllerDelegate <NSObject>

@required
- (void)LSRegisterViewControllerDidRegister;

@end
