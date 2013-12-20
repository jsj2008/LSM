//
//  LSGroupInfoWebCell.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSGroupInfoWebCell.h"

@implementation LSGroupInfoWebCell
@synthesize html=_html;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundView=nil;
        self.backgroundColor=[UIColor clearColor];
        self.clipsToBounds=YES;
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        _tipsWebView=[[UIWebView alloc]initWithFrame:CGRectZero];
        _tipsWebView.delegate=self;
        [self addSubview:_tipsWebView];
        [_tipsWebView release];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tipsWebView.frame=CGRectMake(0.f, 10.f, self.width, self.height-10);
    if(_html!=nil)
    {
        [_tipsWebView loadHTMLString:_html baseURL:nil];
    }
}

#pragma mark- UIWebView的委托方法
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    LSLOG(@"开始加载温馨提示");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    LSLOG(@"结束加载温馨提示");
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    LSLOG(@"加载温馨提示错误 %@",error);
}

@end
