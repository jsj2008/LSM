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
    UITableView* _categoryTableView;
    UITableView* _districtTableView;
    FXBlurView* _blurView;
    NSDictionary* _districtDic;
    NSArray* _categoryArray;
    NSArray* _districtArray;
    NSInteger _selectIndex;
    CGSize _contentSize;
    id<LSDistrictSelectorViewDelegate> _delegate;
}
@property(nonatomic,retain) NSDictionary* districtDic;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,assign) CGSize contentSize;
@property(nonatomic,assign) id<LSDistrictSelectorViewDelegate> delegate;

@end

@protocol LSDistrictSelectorViewDelegate <NSObject>

@required
- (void)LSDistrictSelectorView:(LSDistrictSelectorView*)districtSelectorView didSelectDistrict:(NSString*)district;

@end
