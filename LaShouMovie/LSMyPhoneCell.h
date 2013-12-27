//
//  LSMyPhoneCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@protocol LSMyPhoneCellDelegate;
@interface LSMyPhoneCell : LSTableViewCell
{
    NSString* _imageName;
    NSString* _title;
    NSString* _titleClick;
    UIButton* _bindButton;
    id<LSMyPhoneCellDelegate> _delegate;
}
@property(nonatomic,retain) NSString* title;
@property(nonatomic,retain) NSString* titleClick;
@property(nonatomic,retain) NSString* imageName;
@property(nonatomic,assign) id<LSMyPhoneCellDelegate> delegate;

@end

@protocol LSMyPhoneCellDelegate <NSObject>

@required
- (void)LSMyPhoneCell:(LSMyPhoneCell*)myPhoneCell didClickBindButton:(UIButton*)bindButton;

@end
