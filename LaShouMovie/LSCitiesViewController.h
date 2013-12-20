//
//  LSCitiesViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-6.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"

@protocol LSCitiesViewControllerDelegate;
@interface LSCitiesViewController : LSTableViewController
{
    NSMutableArray* _cityMArray;//包括热门城市和城市列表
    
    NSMutableArray* _titleMArray;//索引
    NSMutableArray* _numberMArray;//数量
    
    NSIndexPath* _indexPath;//记录选择城市
    
    id<LSCitiesViewControllerDelegate> _delegate;
}

@property(nonatomic,assign) id<LSCitiesViewControllerDelegate> delegate;

@end

@protocol LSCitiesViewControllerDelegate <NSObject>

@required
- (void)LSCitiesViewControllerDidSelect;

@end
