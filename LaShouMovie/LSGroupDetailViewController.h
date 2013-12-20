//
//  LSGroupDetailViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSViewController.h"

@interface LSGroupDetailViewController : LSViewController<UIWebViewDelegate>
{
    NSString* _html;
}
@property(nonatomic,retain) NSString* html;

@end
