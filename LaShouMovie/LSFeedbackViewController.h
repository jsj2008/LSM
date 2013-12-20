//
//  LSFeedbackViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

@interface LSFeedbackViewController : LSViewController<UITextViewDelegate,UITextFieldDelegate>
{
    UITextView* _messageTextView;
    UITextField* _addressTextField;
}
@end
