//
//  LSBindPhoneCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSBindPhoneCellDelegate;
@interface LSBindPhoneCell : LSTableViewCell<UITextFieldDelegate>
{
    NSString* _imageName;
    NSString* _placeholder;
    UITextField* _textField;
    UILabel* _label;
    id<LSBindPhoneCellDelegate> _delegate;
}
@property(nonatomic,retain) NSString* imageName;
@property(nonatomic,retain) NSString* placeholder;
@property(nonatomic,retain) UITextField* textField;
@property(nonatomic,assign) id<LSBindPhoneCellDelegate> delegate;

@end

@protocol LSBindPhoneCellDelegate <NSObject>

@required
- (void)LSBindPhoneCell:(LSBindPhoneCell*)cell didTapLabel:(UILabel*)label;

@end
