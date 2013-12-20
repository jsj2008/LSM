//
//  LSGroupInfoGroupCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSGroupInfoSectionHeader.h"

@protocol LSGroupInfoGroupCellDelegate;
@interface LSGroupInfoGroupCell : LSTableViewCell<UITableViewDataSource,UITableViewDelegate,LSGroupInfoSectionHeaderDelegate>
{
    UITableView* _groupTableView;
    NSArray* _groupArray;
    id<LSGroupInfoGroupCellDelegate> _delegate;
    BOOL _isOpen;
}
@property(nonatomic,retain) NSArray* groupArray;
@property(nonatomic,assign) BOOL isOpen;
@property(nonatomic,assign) id<LSGroupInfoGroupCellDelegate> delegate;

@end

@protocol LSGroupInfoGroupCellDelegate <NSObject>

- (void)LSGroupInfoGroupCell:(LSGroupInfoGroupCell*)groupInfoGroupCell isOpen:(BOOL)isOpen;
- (void)LSGroupInfoGroupCell:(LSGroupInfoGroupCell*)groupInfoGroupCell didSelectRowAtIndexPath:(NSInteger)indexPath;

@end
