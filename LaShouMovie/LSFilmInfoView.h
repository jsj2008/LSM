//
//  LSFilmInfoView.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-13.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSFilm.h"

@protocol LSFilmInfoViewDelegate;
@interface LSFilmInfoView : UIView
{
    LSFilm* _film;
    id<LSFilmInfoViewDelegate> _delegate;
}
@property(nonatomic,retain) LSFilm* film;
@property(nonatomic,assign) id<LSFilmInfoViewDelegate> delegate;

@end

@protocol LSFilmInfoViewDelegate <NSObject>

- (void)LSFilmInfoView:(LSFilmInfoView*)filmInfoView didClickForFilm:(LSFilm*)film;

@end
