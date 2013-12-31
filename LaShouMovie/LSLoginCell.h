//
//  LSLoginCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSLoginCell : LSTableViewCell<UITextFieldDelegate>
{
    NSString* _imageName;
    NSString* _placeholder;
    UITextField* _textField;
}
@property(nonatomic,retain) NSString* imageName;
@property(nonatomic,retain) NSString* placeholder;
@property(nonatomic,retain) UITextField* textField;

@end
