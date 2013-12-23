//
//  LSDateSectionHeader.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSDateSectionHeaderDelegate;
@interface LSDateSectionHeader : UIView<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger _date;//选项
    NSString* _today;
    NSMutableArray* _dateMArray;//排期日期数组
    NSMutableArray* _dateTagMArray;//排期日期标记数组
    UITableView* _tableView;
    
    NSArray* _scheduleDicArray;
    id<LSDateSectionHeaderDelegate> _delegate;
}
@property(nonatomic,retain) NSString* today;
@property(nonatomic,assign) NSInteger date;
@property(nonatomic,retain) NSArray* scheduleDicArray;
@property(nonatomic,assign) id<LSDateSectionHeaderDelegate> delegate;

@end

@protocol LSDateSectionHeaderDelegate <NSObject>

@required
- (void)LSDateSectionHeader:(LSDateSectionHeader *)dateSectionHeader didSelectRowAtIndexPath:(int)date;

@end
