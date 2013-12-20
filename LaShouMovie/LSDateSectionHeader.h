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
    NSString* _title;//标题
    NSString* _today;//今天日期
    int _date;//选项
    
    NSMutableArray* _dateMArray;//排期日期数组
    NSMutableArray* _dateTagMArray;//排期日期标记数组
    UITableView* _tableView;
    
    NSArray* _scheduleDicArray;
    id<LSDateSectionHeaderDelegate> _delegate;
}
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* today;
@property(nonatomic,assign) int date;
@property(nonatomic,assign) NSArray* scheduleDicArray;
@property(nonatomic,assign) id<LSDateSectionHeaderDelegate> delegate;

@end

@protocol LSDateSectionHeaderDelegate <NSObject>

- (void)LSDateSectionHeader:(LSDateSectionHeader *)dateSectionHeader didSelectRowAtIndexPath:(int)date;

@end
