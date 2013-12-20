//
//  LSMySectionHeader.h
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-30.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    LSMySectionHeaderTypeMovie=0,
    LSMySectionHeaderTypeGroup=1
    
}LSMySectionHeaderType;

@protocol LSMySectionHeaderDelegate;
@interface LSMySectionHeader : UIView
{
    BOOL _isOpen;
    LSMySectionHeaderType _mySectionHeaderType;
    id<LSMySectionHeaderDelegate> _delegate;
}
@property(nonatomic,assign) BOOL isOpen;
@property(nonatomic,assign) LSMySectionHeaderType mySectionHeaderType;
@property(nonatomic,assign) id<LSMySectionHeaderDelegate> delegate;

@end

@protocol LSMySectionHeaderDelegate <NSObject>

- (void)LSMySectionHeader:(LSMySectionHeader*)mySectionHeader isOpen:(BOOL)isOpen;

@end
