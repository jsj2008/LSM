//
//  LSFilmListCell.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTableViewCell.h"
#import "LSFilm.h"
#import "LSQuickBuyView.h"

@protocol LSFilmListShowCellDelegate;
@interface LSFilmListShowCell : LSTableViewCell<LSQuickBuyViewDelegate>
{
    //高度90.f
    BOOL _isUseHitTest;
    
    LSMessageCenter* messageCenter;
    
    LSQuickBuyView* _quickBuyView;
    
    UIImageView* _filmImageView;//显示电影图片
    UIImageView* _starImageView;//显示星级图片
    
    LSFilm* _film;
    id<LSFilmListShowCellDelegate> _delegate;
}
@property(nonatomic,retain) UIImageView* filmImageView;
@property(nonatomic,retain) LSFilm* film;
@property(nonatomic,assign) id<LSFilmListShowCellDelegate> delegate;

@end

@protocol LSFilmListShowCellDelegate <NSObject>

@required
- (void)LSFilmListShowCell:(LSFilmListShowCell*)filmListShowCell didClickQuickBuyView:(LSQuickBuyView*)quickBuyView;

@end
