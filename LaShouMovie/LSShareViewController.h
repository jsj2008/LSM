//
//  LSShareViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-21.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

@interface LSShareViewController : LSViewController<UITextViewDelegate,NSURLConnectionDelegate>
{
    UITextView* _shareTextView;
    UILabel* _countLabel;
    NSString* _message;
    NSString* _imgURL;
    LSShareType _shareType;
    NSMutableData* _responsMData;
}
@property(nonatomic,retain) NSString* message;
@property(nonatomic,retain) NSString* imgURL;
@property(nonatomic,assign) LSShareType shareType;

@end
