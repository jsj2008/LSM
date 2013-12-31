//
//  LSCouponsViewController.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewController.h"

@interface LSCouponsViewController : LSTableViewController
{
    NSMutableArray* _couponMArray;
    
    int _offset;
    int _pageSize;
    BOOL _isRefresh;//刷新标记
    BOOL _isAdd;//添加标记
}

@end
