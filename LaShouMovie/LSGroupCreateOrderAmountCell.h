//
//  LSGroupCreateOrderAmountCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-11.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSGroup.h"

@protocol LSGroupCreateOrderAmountCellDelegate;
@interface LSGroupCreateOrderAmountCell : LSTableViewCell<UITextFieldDelegate>
{
    UIButton* _addButton;
    UITextField* _amountTextField;
    UIButton* _minusButton;
    LSGroup* _group;
    NSInteger _amount;
    id<LSGroupCreateOrderAmountCellDelegate> _delegate;
}
@property(nonatomic,retain) LSGroup* group;
@property(nonatomic,assign) id<LSGroupCreateOrderAmountCellDelegate> delegate;

@end

@protocol LSGroupCreateOrderAmountCellDelegate <NSObject>

- (void)LSGroupCreateOrderAmountCell:(LSGroupCreateOrderAmountCell*)groupCreateOrderAmountCell didChangeAmount:(NSInteger)amount;

@end
