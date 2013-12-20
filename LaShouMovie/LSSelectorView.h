//
//  LSSelectorView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSSelectorCell.h"

@protocol LSSelectorViewDelegate;
@interface LSSelectorView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    LSSelectorViewType _selectorViewType;
    NSArray* _positionArray;
    NSInteger _selectIndex;
    UITableView* _tableView;
    UIButton* _button;
    CGRect _contentFrame;
    
    id<LSSelectorViewDelegate> _delegate;
}

@property(nonatomic,assign) LSSelectorViewType selectorViewType;
@property(nonatomic,retain) NSArray* positionArray;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) CGRect contentFrame;
@property(nonatomic,assign) id<LSSelectorViewDelegate> delegate;

@end

@protocol LSSelectorViewDelegate <NSObject>

- (void)LSSelectorView:(LSSelectorView*)selectorView didSelectRowAtIndexPath:(NSInteger)indexPath;

@end
