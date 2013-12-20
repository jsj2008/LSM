//
//  UPOMP_BootViewController.h
//  UPOMP
//
//  Created by pei xunjun on 12-3-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPOMP_KaNet.h"
@class UPOMP;


@interface UPOMP_BootViewController : UIViewController<UIAlertViewDelegate,UPOMP_KaNetDelegate>{
    IBOutlet UIImageView *bg;
    IBOutlet UILabel *loadingText1;
    IBOutlet UILabel *infoText;
    IBOutlet UILabel *loadingText2;
    IBOutlet UIImageView *loadingLogo;
    IBOutlet UIImageView *loadingLine;
    IBOutlet UIImageView *loadingMove;
    IBOutlet UILabel *logoLabel;
    UPOMP *upomp;
    UIAlertView *alert;
    UPOMP_KaNet *net;
    BOOL needReconnect;
    int netMode;
    NSTimer *timer;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil upomp:(UPOMP*)obj;
- (void)setAlertTitel:(NSString*)tString info:(NSString*)iString;
- (void)netWorkStart:(NSString*)str;
- (void)startLoad;
- (void)stopLoad;
@end
