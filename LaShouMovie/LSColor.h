//
//  LSColor.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-14.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <Foundation/Foundation.h>

//快捷颜色
#define LSRGBA(r,g,b,a)             [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define LSColorButtonNormalRed            LSRGBA(190.f, 43.f, 43.f, 1.f)
#define LSColorButtonHighlightedRed       LSRGBA(156.f, 21.f, 21.f, 1.f)

#define LSColorNavigationRed              LSRGBA(190.f, 43.f, 43.f, 0.9f)
#define LSColorTabBlack                   LSRGBA(29.f, 33.f, 35.f, 0.9f)
#define LSColorBackgroundGray             LSRGBA(238.f, 238.f, 238.f, 1.f)
#define LSColorSeparatorLineGray          LSRGBA(211.f, 211.f, 211.f, 1.f)

#define LSColorTextBlack                  LSRGBA(44.f, 46.f, 50.f, 1.f)
#define LSColorTextGray                   LSRGBA(147.f, 148.f, 152.f, 1.f)
#define LSColorTextLightGray              LSRGBA(191.f, 191.f, 191.f, 1.f)
#define LSColorTextRed                    LSRGBA(235.f, 64.f, 59.f, 1.f)

@interface LSColor : NSObject

@end
