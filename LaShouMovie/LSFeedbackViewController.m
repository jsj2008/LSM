//
//  LSFeedbackViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-8-29.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSFeedbackViewController.h"
#import "LSFeedbackView.h"

@interface LSFeedbackViewController ()

@end

@implementation LSFeedbackViewController

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
    self.title=@"意见反馈";
    
    LSFeedbackView* feedbackView=[[LSFeedbackView alloc] initWithFrame:CGRectZero];
    feedbackView.backgroundColor=[UIColor clearColor];
    feedbackView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view=feedbackView;
    [feedbackView release];
    
    UITapGestureRecognizer* tapGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfTap:)];
    tapGestureRecognizer.delegate=self;
    [self.view addGestureRecognizer:tapGestureRecognizer];
    [tapGestureRecognizer release];
    
    [messageCenter addObserver:self selector:@selector(lsHttpRequestNotification:) name:lsRequestTypeFeedbackByContent_Contact object:nil];
    
    _messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 41, 270, 148)];
    _messageTextView.delegate = self;
    _messageTextView.backgroundColor = [UIColor clearColor];
    _messageTextView.font = [UIFont systemFontOfSize:15.0f];
    _messageTextView.textColor = [UIColor lightGrayColor];
    _messageTextView.text=@"请尽量详细描述，以方面我们解决问题，谢谢！";
    [self.view addSubview:_messageTextView];
    [_messageTextView release];
    
    _addressTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 237, 280, 30)];
    _addressTextField.delegate = self;
    _addressTextField.placeholder = @"手机或电子邮箱(选填)";
    _addressTextField.textColor = [UIColor blackColor];
    _addressTextField.font = LSFont15;
    _addressTextField.borderStyle = UITextBorderStyleNone;
    _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _addressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _addressTextField.keyboardType = UIKeyboardTypeEmailAddress;
    [self.view addSubview:_addressTextField];
    [_addressTextField release];
    
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    submitButton.frame = CGRectMake(15, 285, 290, 46);
    [submitButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateNormal];
    [submitButton setBackgroundImage:[UIImage stretchableImageWithImage:[UIImage lsImageNamed:@"corder_confirm_d.png"] top:23 left:4 bottom:23 right:4] forState:UIControlStateHighlighted];
    submitButton.titleLabel.font = LSFontBold18;
    [submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark- 消息中心通知
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
            if([notification.name isEqualToString:lsRequestTypeFeedbackByContent_Contact])
            {
                LSStatus* status=notification.object;
                if(status.code==5)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [LSAlertView showWithTag:-1 title:nil message:status.message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                }
                //状态
                return;
            }
        }
        
        if([notification.object isKindOfClass:[LSError class]])
        {
            //错误
            return;
        }
    }
}


#pragma mark- UITextView的委托方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	if ([textView.text isEqualToString:@"请尽量详细描述，以方面我们解决问题，谢谢！"])
    {
		textView.textColor = [UIColor blackColor];
		textView.text = nil;
	}
	return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
	if (!textView.hasText)
    {
		textView.textColor = [UIColor lightGrayColor];
		textView.text = @"请尽量详细描述，以方面我们解决问题，谢谢！";
	}
	return YES;
}

#pragma mark- UITextField的委托方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.view.frame=CGRectMake(-80, 0, 0, 0);
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.view.frame=CGRectMake(0, 0, 0, 0);
    return YES;
}

#pragma mark- 按钮单击方法
- (void)submitButtonClick:(UIButton*)button
{
    if(![_messageTextView.text isEqualToString:@"请尽量详细描述，以方面我们解决问题，谢谢！"] && _messageTextView.text!=nil)
    {
        [messageCenter LSMCFeedbackWithContent:_messageTextView.text contact:_addressTextField.text];
        [hud show:YES];
    }
}

- (void)selfTap:(UITapGestureRecognizer*)recognizer
{
    [_addressTextField resignFirstResponder];
    [_messageTextView resignFirstResponder];
}

@end
