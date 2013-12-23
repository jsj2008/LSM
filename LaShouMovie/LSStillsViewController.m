//
//  LSStillsViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-16.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSStillsViewController.h"
#import "LSStillCell.h"

@interface LSStillsViewController ()

@end

@implementation LSStillsViewController

@synthesize film=_film;

- (void)dealloc
{
    self.film=nil;
    [super dealloc];
}

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
    self.title=@"海报";
    self.tableView.backgroundColor=[UIColor blackColor];
    
    self.tableView.bounds=CGRectMake(0.f, 0.f, self.view.height, self.view.width);
    self.tableView.transform=CGAffineTransformMakeRotation(-M_PI/2);//将视图旋转90
    self.tableView.pagingEnabled=YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _film.stillArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.view.width;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSStillCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSStillCell"];
    if(cell==nil)
    {
        cell=[[[LSStillCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSStillCell"] autorelease];
        cell.transform=CGAffineTransformMakeRotation(M_PI/2);//将视图旋转90
    }
    NSString* stillStr=[_film.stillArray objectAtIndex:indexPath.row];
    cell.stillURL=stillStr;
    NSMutableString* stillMStr=[NSMutableString stringWithString:stillStr];
    [stillMStr replaceOccurrencesOfString:_film.stillPath withString:_film.bigStillPath options:NSCaseInsensitiveSearch range:NSMakeRange(0, stillMStr.length)];
    cell.bigStillURL=stillMStr;
    [cell setNeedsLayout];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.navigationController.navigationBar.isHidden)
    {
        self.navigationController.navigationBar.hidden=NO;
    }
    else
    {
        self.navigationController.navigationBar.hidden=YES;
    }
}

@end
