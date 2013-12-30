//
//  LSCouponsViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-12-27.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCouponsViewController.h"
#import "LSCoupon.h"
#import "LSCouponCell.h"

@interface LSCouponsViewController ()

@end

@implementation LSCouponsViewController

- (void)dealloc
{
    LSRELEASE(_couponMArray)
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
    _couponMArray=[[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITableView的委托方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _couponMArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LSCouponCell* cell=[tableView dequeueReusableCellWithIdentifier:@"LSCouponCell"];
    if(cell==nil)
    {
        cell=[[[LSCouponCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LSCouponCell"] autorelease];
    }
    cell.coupon=[_couponMArray objectAtIndex:indexPath.row];
    [cell setNeedsDisplay];
    return cell;
}

@end
