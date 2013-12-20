//
//  LSCinemasMapViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-9-10.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemasMapViewController.h"
#import "LSCinema.h"
#import "LSAnnotationView.h"
#import "LSFilmsSchedulesByCinemaViewController.h"

@interface LSCinemasMapViewController ()

@end

@implementation LSCinemasMapViewController

@synthesize cinemaArray=_cinemaArray;

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
    self.title=@"影院";
    
    _mapView=[[MKMapView alloc] init];
    _mapView.frame=CGRectMake(0.f, 0.f, 320.f, HeightOfiPhoneX(460.f-44.f));
    _mapView.mapType=MKMapTypeStandard;//标准地图模式
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    [_mapView release];
    
    if(_cinemaArray.count==0 || [[_cinemaArray objectAtIndex:0] isKindOfClass:[NSString class]])
    {
        [LSAlertView showWithTag:0 title:nil message:@"没有影院" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    }
    else
    {
        LSAnnotation* topAnnotation=nil;
        LSAnnotation* bottomAnnotation=nil;
        LSAnnotation* leftAnnotation=nil;
        LSAnnotation* rightAnnotation=nil;
        
        double maxX=0.f;
        double minX=INT32_MAX;
        double maxY=0.f;
        double minY=INT32_MAX;
        
        for(LSCinema* cinema in _cinemaArray)
        {
            if(cinema.latitude<=0 || cinema.latitude<=0)
            {
                continue;
            }
            
            CLLocationCoordinate2D locationCoordinate2D=CLLocationCoordinate2DMake(cinema.latitude, cinema.longitude);
            LSAnnotation* annotation=[[LSAnnotation alloc] initWithTitle:cinema.cinemaName subTitle:cinema.address coordinate:locationCoordinate2D];
            annotation.cinema=cinema;
            [_mapView addAnnotation:annotation];
            [annotation release];

            if(maxX<annotation.coordinate.longitude)
            {
                maxX=annotation.coordinate.longitude;
                rightAnnotation=annotation;
            }
            if(minX>annotation.coordinate.longitude)
            {
                minX=annotation.coordinate.longitude;
                leftAnnotation=annotation;
            }
            if(maxY<annotation.coordinate.latitude)
            {
                maxY=annotation.coordinate.latitude;
                topAnnotation=annotation;
            }
            if(minY>annotation.coordinate.latitude)
            {
                minY=annotation.coordinate.latitude;
                bottomAnnotation=annotation;
            }
        }
        
        double midX=(maxX+minX)/2;
        double midY=(maxY+minY)/2;
        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake(midY, midX);
        
        MKCoordinateSpan span=MKCoordinateSpanMake(0.1,0.1);
        MKCoordinateRegion region=MKCoordinateRegionMake(coordinate, span);
        [_mapView setRegion:region animated:NO];//显示偏移与缩放动画效果
        
        dispatch_queue_t queue_0=dispatch_queue_create("queue_0", NULL);
        dispatch_async(queue_0, ^{
            
            CGPoint topPoint=[_mapView convertCoordinate:topAnnotation.coordinate toPointToView:_mapView];
            CGPoint bottomPoint=[_mapView convertCoordinate:bottomAnnotation.coordinate toPointToView:_mapView];
            CGPoint leftPoint=[_mapView convertCoordinate:leftAnnotation.coordinate toPointToView:_mapView];
            CGPoint rightPoint=[_mapView convertCoordinate:rightAnnotation.coordinate toPointToView:_mapView];
            
            CGFloat halfMapWidth= _mapView.width/2;
            CGFloat halfMapHeight= _mapView.height/2;
            
            CGFloat x;
            if(halfMapWidth-leftPoint.x > rightPoint.x-halfMapWidth)
            {
                x=halfMapWidth-leftPoint.x;
            }
            else
            {
                x=rightPoint.x-halfMapWidth;
            }
            
            CGFloat y;
            if(halfMapHeight-topPoint.y > bottomPoint.y-halfMapHeight)
            {
                y=halfMapHeight-topPoint.y;
            }
            else
            {
                y=bottomPoint.y-halfMapHeight;
            }
            
            CGFloat zoomX= x/halfMapWidth;
            CGFloat zoomY= y/halfMapHeight;
            
            CGFloat zoom;
            if(zoomX > zoomY)
            {
                zoom=0.1*zoomX;
            }
            else
            {
                zoom=0.1*zoomY;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MKCoordinateSpan span=MKCoordinateSpanMake(zoom,zoom);
                MKCoordinateRegion region=MKCoordinateRegionMake(coordinate, span);
                [_mapView setRegion:region animated:YES];//显示偏移与缩放动画效果
            });
        });
        dispatch_release(queue_0);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- MKMapView的委托方法
- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    LSLOG(@"生成一个大头针");

    LSAnnotationView* annotationView = [[[LSAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"LSAnnotationView"] autorelease];
#warning 生成自定义大头针的时候，如果是MKAnnotationView的子类，是不可以复用的，否则会出现不知名错误
    
    UIButton* goButton=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [goButton addTarget:self action:@selector(goButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    annotationView.rightCalloutAccessoryView=goButton;

    return annotationView;
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    LSRELEASE(_selectAnnotation)
    _selectAnnotation=[view.annotation retain];
}


#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==alertView.cancelButtonIndex)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)goButtonClick:(UIButton*)sender
{
    LSFilmsSchedulesByCinemaViewController* filmsSchedulesByCinemaViewController=[[LSFilmsSchedulesByCinemaViewController alloc] init];
    filmsSchedulesByCinemaViewController.cinema=_selectAnnotation.cinema;
    filmsSchedulesByCinemaViewController.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:filmsSchedulesByCinemaViewController animated:YES];
    [filmsSchedulesByCinemaViewController release];
}

@end
