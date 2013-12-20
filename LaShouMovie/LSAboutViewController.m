//
//  LSAboutViewController.m
//  LaShouMovie
//
//  Created by Li XiangYu on 13-10-4.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSAboutViewController.h"
#import "LSAboutLogoCell.h"
#import "LSAboutBriefCell.h"
#import "LSAboutVersionCell.h"

@interface LSAboutViewController ()

@end

@implementation LSAboutViewController

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
    self.title=@"关于拉手电影";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        return 200;
    }
    else if(indexPath.row==1)
    {
        return 140;
    }
    else
    {
        return self.view.height-340;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        LSAboutLogoCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSAboutLogoCell"];
        if(cell==nil)
        {
            cell=[[[LSAboutLogoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSAboutLogoCell"] autorelease];
        }
        return cell;
    }
    else if(indexPath.row==1)
    {
        LSAboutBriefCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSAboutBriefCell"];
        if(cell==nil)
        {
            cell=[[[LSAboutBriefCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSAboutBriefCell"] autorelease];
        }
        return cell;
    }
    else
    {
        LSAboutVersionCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSAboutVersionCell"];
        if(cell==nil)
        {
            cell=[[[LSAboutVersionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSAboutVersionCell"] autorelease];
        }
        return cell;
    }
}

@end
