//
//  LSShareViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-21.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSShareViewController.h"
#import "NSObject+SBJSON.h"
#import "NSString+SBJSON.h"

@interface LSShareViewController ()

@end

@implementation LSShareViewController

@synthesize message=_message;
@synthesize imgURL=_imgURL;
@synthesize shareType=_shareType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    if(_shareType==LSShareTypeSinaWB)
    {
        self.title=@"分享到新浪微博";
    }
    else if(_shareType==LSShareTypeQQWB)
    {
        self.title=@"分享到腾讯微博";
    }
    
    [messageCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeShareSinaWBShareByMessage_Img object:nil];
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeShareQQWBShareByMessage_Img object:nil];
    
    [self setBarButtonItemWithImageName:@"nav_n.png" clickedImageName:@"nav_n_d.png" title:@"发送" isRight:YES buttonType:LSOtherButtonTypeDone];
    
    _shareTextView=[[UITextView alloc] initWithFrame:CGRectMake(5.f, 0.f, 310.f, self.view.height-20.f)];
    _shareTextView.backgroundColor=[UIColor clearColor];
    _shareTextView.font=LSFont17;
    _shareTextView.delegate=self;
    [self.view addSubview:_shareTextView];
    [_shareTextView release];
    
    [_shareTextView becomeFirstResponder];
    if(_message.length>140)
    {
        self.message=[_message substringToIndex:140];
        [LSAlertView showWithView:_shareTextView message:@"最多140字" time:3.5f];
    }
    _shareTextView.text=_message;
    
    _countLabel=[[UILabel alloc] initWithFrame:CGRectMake(5.f, self.view.height-20.f, 310.f, 20.f)];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.font = [UIFont systemFontOfSize:15.f];
    _countLabel.textColor = [UIColor lightGrayColor];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.text=[NSString stringWithFormat:@"还可以再输入%d字",140-_message.length];
    [self.view addSubview:_countLabel];
    [_countLabel release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 重载方法
- (void)otherButtonClick:(UIButton *)sender
{
    [super otherButtonClick:sender];
    if(sender.tag==LSOtherButtonTypeDone)
    {
        if(_shareType==LSShareTypeSinaWB)
        {
            [messageCenter LSMCShareSinaWBShareWithMessage:_message img:_imgURL];
        }
        else if(_shareType==LSShareTypeQQWB)
        {
            [messageCenter LSMCShareQQWBShareWithMessage:_message img:_imgURL];
        }
        [hud show:YES];
    }
}

#pragma mark- 私有方法
- (void)keyboardWillShow:(NSNotification*)notification
{
    //得到键盘的高度
    CGFloat keyboardHeight=[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    LSLOG(@"%f",keyboardHeight);
    
    _shareTextView.frame=CGRectMake(5.f, 0.f, 310.f, self.view.height-keyboardHeight-30.f);
    _countLabel.frame=CGRectMake(5.f, self.view.height-keyboardHeight-30.f, 310.f, 20.f);
}

- (void)delayToPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 通知中心消息
- (void)lsHttpRequestNotification:(NSNotification*)notification
{
    [hud hide:YES];
    if([self checkIsNotEmpty:notification])
    {
        if([notification.object isEqual:lsRequestFailed])
        {
            //超时
            return;
        }
        
        if([notification.object isKindOfClass:[LSStatus class]])
        {
            if([notification.name isEqualToString:lsRequestTypeShareSinaWBShareByMessage_Img] || [notification.name isEqualToString:lsRequestTypeShareQQWBShareByMessage_Img])
            {
                LSStatus* status=notification.object;
                [LSAlertView showWithTag:-1 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
            //状态
            return;
        } 
        
        if([notification.object isKindOfClass:[LSError class]])
        {
            //错误
            return;
        }
        
        if([notification.name isEqualToString:lsRequestTypeShareSinaWBShareByMessage_Img])
        {
            if([notification.object objectForKey:@"visible"])
            {
                [LSAlertView showWithView:_shareTextView message:@"分享到新浪微博" time:2.f];
                [self performSelector:@selector(delayToPop) withObject:nil afterDelay:3.f];
            }
        }
        else if([notification.name isEqualToString:lsRequestTypeShareQQWBShareByMessage_Img])
        {
            if([notification.object objectForKey:@"msg"])
            {
                NSString* msg=[notification.object objectForKey:@"msg"];
                if([msg isEqual:@"ok"])
                {
                    [LSAlertView showWithView:_shareTextView message:@"分享到腾讯微博" time:2.f];
                    [self performSelector:@selector(delayToPop) withObject:nil afterDelay:2.f];
                }
            }
        }
    }
}

#pragma mark- UITextView的委托方法
- (void)textViewDidChange:(UITextView *)textView
{
    if(textView.text.length>140)
    {
        [LSAlertView showWithView:self.view message:@"最多140字" time:2];
        textView.text=_message;
    }
    else
    {
        self.message=textView.text;
        _countLabel.text=[NSString stringWithFormat:@"还可以再输入%d字",140-_message.length];
    }
}

@end
