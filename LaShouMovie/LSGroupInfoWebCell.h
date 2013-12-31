//
//  LSGroupInfoWebCell.h
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"

@interface LSGroupInfoWebCell : LSTableViewCell<UIWebViewDelegate>
{
    UIWebView* _tipsWebView;
    NSString* _html;
}
@property(nonatomic,retain) NSString* html;

@end
