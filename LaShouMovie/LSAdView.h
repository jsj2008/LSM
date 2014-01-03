//
//  LSAdView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-9.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAdvertisment.h"

@protocol LSAdViewDelegate;
@interface LSAdView : UIView
{
    UIImageView* _adImageView;
    
    id<LSAdViewDelegate> _delegate;
    LSAdvertisment* _advertisment;
}
@property(nonatomic,assign) id<LSAdViewDelegate> delegate;
@property(nonatomic,retain) LSAdvertisment* advertisment;

@end

@protocol LSAdViewDelegate <NSObject>

@required
- (void)LSAdViewDidClose;
- (void)LSAdViewDidSelect;

@end
