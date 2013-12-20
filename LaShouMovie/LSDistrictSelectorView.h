//
//  LSDistrictSelectorView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-20.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSDistrictSelectorViewDelegate;
@interface LSDistrictSelectorView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView* _districtTableView;
    NSArray* _positionArray;
    NSInteger _selectIndex;
    CGRect _contentFrame;
    id<LSDistrictSelectorViewDelegate> _delegate;
}
@property(nonatomic,retain) NSArray* positionArray;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) CGRect contentFrame;
@property(nonatomic,assign) id<LSDistrictSelectorViewDelegate> delegate;

@end

@protocol LSDistrictSelectorViewDelegate <NSObject>

- (void)LSDistrictSelectorView:(LSDistrictSelectorView*)districtSelectorView didSelectRowAtIndexPath:(NSInteger)indexPath;

@end
