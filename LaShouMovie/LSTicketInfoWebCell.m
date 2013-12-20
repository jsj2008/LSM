//
//  LSTicketInfoWebCell.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-17.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSTicketInfoWebCell.h"

@implementation LSTicketInfoWebCell

@synthesize html=_html;
@synthesize delegate=_delegate;

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
        _tipsWebView.scrollView.scrollEnabled=NO;
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
    if([_delegate respondsToSelector:@selector(LSTicketInfoWebCellDidLoadHTMLContentHeight:)])
    {
        [_delegate LSTicketInfoWebCellDidLoadHTMLContentHeight:webView.scrollView.contentSize.height];
    }
    self.delegate=nil;
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    LSLOG(@"加载温馨提示错误 %@",error);
}

@end
