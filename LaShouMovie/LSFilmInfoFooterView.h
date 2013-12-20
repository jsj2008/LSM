//
//  LSFilmInfoFooterView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-20.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSFilmInfoFooterViewDelegate;
@interface LSFilmInfoFooterView : UIView
{
    UIButton* _selectButton;
    id<LSFilmInfoFooterViewDelegate> _delegate;
}
@property(nonatomic,assign) id<LSFilmInfoFooterViewDelegate> delegate;

@end

@protocol LSFilmInfoFooterViewDelegate <NSObject>

@required
- (void)LSFilmInfoFooterView:(LSFilmInfoFooterView*)filmInfoFooterView didClickSelectButton:(UIButton*)selectButton;

@end
