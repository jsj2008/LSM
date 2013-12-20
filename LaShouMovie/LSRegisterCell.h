//
//  LSRegisterCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-18.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSRegisterCell : LSTableViewCell
{
    NSString* _imageName;
    NSString* _placeholder;
    UITextField* _textField;
    UIKeyboardType _keyboardType;
}
@property(nonatomic,retain) NSString* imageName;
@property(nonatomic,retain) NSString* placeholder;
@property(nonatomic,retain) UITextField* textField;
@property(nonatomic,assign) UIKeyboardType keyboardType;

@end
