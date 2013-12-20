//
//  LSCinemaMapViewController.m
//  LaShouMovie
//
//  Created by LiXiangYu on 13-10-12.
//  Copyright (c) 2013年 LiXiangYu. All rights reserved.
//

#import "LSCinemaMapViewController.h"
#import "LSRootAnnotation.h"
#import "LSCinemaAnnotation.h"

@interface LSCinemaMapViewController ()

@end

@implementation LSCinemaMapViewController

@synthesize cinema=_cinema;

- (void)dealloc
{
    self.cinema=nil;
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
    self.title=@"地址";
    
    _mapView=[[MKMapView alloc] init];
    _mapView.frame=CGRectMake(0.f, 0.f, 320.f, HeightOfiPhoneX(460.f-44.f));
    _mapView.mapType=MKMapTypeStandard;//标准地图模式
    _mapView.delegate=self;
    [self.view addSubview:_mapView];
    [_mapView release];
    
    _locationImageView=[[UIImageView alloc] initWithImage:[UIImage lsImageNamed:@"selfLocation.png"]];
    _locationImageView.bounds=CGRectMake(0.f, 0.f, 26.f, 26.f);
    _locationImageView.center=CGPointMake(_mapView.width/2+5.f, _mapView.height/2+10.f);
    [_mapView addSubview:_locationImageView];
    [_locationImageView release];
    _locationImageView.hidden=YES;

    //基础定位服务
    if([CLLocationManager locationServicesEnabled])//判断是否定位可用
    {
        if(![user.locationCityID isEqualToString:user.cityID])
        {
            LSLOG(@"用户当前不在定位城市");
            [self makeCinemaAnnotation];
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusRestricted)
        {
            LSLOG(@"未知原因导致不能使用定位服务");
            [self makeCinemaAnnotation];
        }
        else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)
        {
            LSLOG(@"用户禁止了定位服务");
            [self makeCinemaAnnotation];
        }
        else
        {
            _mapView.showsUserLocation=YES;
        }
    }
    else
    {
        LSLOG(@"当前定位功能不可用");
        [self makeCinemaAnnotation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 私有方法
- (void)makeCinemaAnnotation
{
    LSCinemaAnnotation* cinemaAnnotation=[[LSCinemaAnnotation alloc] initWithTitle:_cinema.cinemaName subTitle:_cinema.address coordinate:CLLocationCoordinate2DMake(_cinema.latitude, _cinema.longitude)];
    [_mapView addAnnotation:cinemaAnnotation];
    [cinemaAnnotation release];
}

#pragma mark- MKMapView的委托方法
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    LSLOG(@"地图将要移动");
    
    if(mapView.annotations.count>0)//有根注释，不是地图初始化时的移动
    {
        LSLOG(@"地图注释数量: %d",mapView.annotations.count);
        
        if(mapView.annotations.count==1)
        {
            if([[mapView.annotations objectAtIndex:0] isKindOfClass:[MKUserLocation class]])
            {
                _isLocation=YES;
            }
            else
            {
                [mapView deselectAnnotation:[mapView.annotations objectAtIndex:0] animated:YES];
            }
        }
        else if([[mapView.annotations objectAtIndex:0] isKindOfClass:[LSRootAnnotation class]] || [[mapView.annotations objectAtIndex:1] isKindOfClass:[LSRootAnnotation class]])
        {
            LSRootAnnotation* rootAnnotation=nil;
            if([[mapView.annotations objectAtIndex:0] isKindOfClass:[LSRootAnnotation class]])
            {
                rootAnnotation=[mapView.annotations objectAtIndex:0];
            }
            else if([[mapView.annotations objectAtIndex:1] isKindOfClass:[LSRootAnnotation class]])
            {
                rootAnnotation=[mapView.annotations objectAtIndex:1];
            }
            [mapView deselectAnnotation:rootAnnotation animated:YES];
        }
    }
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    LSLOG(@"地图已经移动");
    
    CLLocationCoordinate2D coordinate=[mapView convertPoint:mapView.center toCoordinateFromView:mapView];//将地图中心点转换为经纬度坐标
    LSLOG(@"移动位置:latitude %f, longitude %f",coordinate.latitude,coordinate.longitude);
    _location=[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];//生成一个位置

    if(mapView.annotations.count>0)//如果当前大头针数量不为0，说明是定位或者用户拖动产生的移动
    {
        LSLOG(@"地图注释数量: %d",mapView.annotations.count);
        if(mapView.annotations.count==1)
        {
            if([[mapView.annotations objectAtIndex:0] isKindOfClass:[MKUserLocation class]])
            {
                if(_isLocation)
                {
                    [self makeCinemaAnnotation];
                }
            }
            else
            {
                if(_isCanShowRootAnnotation)
                {
                    _locationImageView.hidden=NO;
                    
                    LSRootAnnotation* rootAnnotation=[[LSRootAnnotation alloc] initWithTitle:@"新位置" subTitle:nil coordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
                    [_mapView addAnnotation:rootAnnotation];
                    [rootAnnotation release];
                }
                else
                {
                    [self showMovieInfo];
                }
            }
        }
        else if([[mapView.annotations objectAtIndex:0] isKindOfClass:[MKUserLocation class]] || [[mapView.annotations objectAtIndex:1] isKindOfClass:[MKUserLocation class]])
        {
            if(!_isAdapt && !_isAnnotation)
            {
                //设置地图的显示就OK了
                mapView.showsUserLocation=NO;
                _locationImageView.hidden=NO;
                
                LSRootAnnotation* rootAnnotation=[[LSRootAnnotation alloc] initWithTitle:@"新位置" subTitle:nil coordinate:CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)];
                [_mapView addAnnotation:rootAnnotation];
                [rootAnnotation release];
            }
            
            if(_isAnnotation)
            {
                _isAnnotation=NO;
            }
        }
        else if([[mapView.annotations objectAtIndex:0] isKindOfClass:[LSRootAnnotation class]] || [[mapView.annotations objectAtIndex:1] isKindOfClass:[LSRootAnnotation class]])
        {
            LSRootAnnotation* rootAnnotation=nil;
            if([[mapView.annotations objectAtIndex:0] isKindOfClass:[LSRootAnnotation class]])
            {
                rootAnnotation=[mapView.annotations objectAtIndex:0];//获取根注释
            }
            else if([[mapView.annotations objectAtIndex:1] isKindOfClass:[LSRootAnnotation class]])
            {
                rootAnnotation=[mapView.annotations objectAtIndex:1];//获取根注释
            }
            [mapView deselectAnnotation:rootAnnotation animated:YES];
            rootAnnotation.coordinate=coordinate;//设置大头针的经纬度
            [self VeivoReverseGeocodeLocation];
        }
    }
}

- (MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    LSLOG(@"生成一个大头针");
    
    if([annotation isKindOfClass:[MKUserLocation class]])
    {
        LSLOG(@"用户位置不生成针");
        return nil;
    }
    else if([annotation isKindOfClass:[LSCinemaAnnotation class]])
    {
        LSLOG(@"影院位置生成针");
        MKPinAnnotationView* annotationView=[[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MKPinAnnotationView"] autorelease];
        UIButton* button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView=button;
        annotationView.canShowCallout=YES;
        return annotationView;
    }
    else if([annotation isKindOfClass:[LSRootAnnotation class]])
    {
        LSLOG(@"自定义位置不生成针");
        MKAnnotationView* annotationView=[[[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MKAnnotationView"] autorelease];
        UIButton* button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView=button;
        annotationView.canShowCallout=YES;
        return annotationView;
    }
    else
    {
        return nil;
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    if(mapView.annotations.count==1)
    {
        if([[mapView.annotations objectAtIndex:0] isKindOfClass:[MKUserLocation class]])
        {
            //反编译用户位置
            MKUserLocation* userLocation=[mapView.annotations objectAtIndex:0];
            _location=userLocation.location;
            [self VeivoReverseGeocodeLocation];
            
            MKCoordinateSpan span=MKCoordinateSpanMake(0.1,0.1);
            MKCoordinateRegion region=MKCoordinateRegionMake(_mapView.userLocation.coordinate, span);
            [_mapView setRegion:region animated:YES];//显示偏移与缩放动画效果
        }
        else
        {
            LSCinemaAnnotation* cinemaAnnotation=[mapView.annotations objectAtIndex:0];
            MKCoordinateSpan span=MKCoordinateSpanMake(0.1, 0.1);
            MKCoordinateRegion region=MKCoordinateRegionMake(cinemaAnnotation.coordinate, span);
            [_mapView setRegion:region animated:YES];//显示偏移与缩放动画效果
        }
    }
    else if([[mapView.annotations objectAtIndex:0] isKindOfClass:[LSRootAnnotation class]] || [[mapView.annotations objectAtIndex:1] isKindOfClass:[LSRootAnnotation class]])
    {
        LSLOG(@"反编译位置");
        [self VeivoReverseGeocodeLocation];
    }
    else if([[mapView.annotations objectAtIndex:0] isKindOfClass:[LSCinemaAnnotation class]] || [[mapView.annotations objectAtIndex:1] isKindOfClass:[LSCinemaAnnotation class]])
    {
        //当前地图缩放为适应缩放
        _isAdapt=YES;
        
        LSCinemaAnnotation* cinemaAnnotation=nil;
        if([[_mapView.annotations objectAtIndex:0] isKindOfClass:[LSCinemaAnnotation class]])
        {
            cinemaAnnotation=[_mapView.annotations objectAtIndex:0];
        }
        else if([[_mapView.annotations objectAtIndex:1] isKindOfClass:[LSCinemaAnnotation class]])
        {
            cinemaAnnotation=[_mapView.annotations objectAtIndex:1];
        }
        CGPoint point=[_mapView convertCoordinate:cinemaAnnotation.coordinate toPointToView:_mapView];
        
        LSLOG(@"影院位置坐标 %f,%f",point.x,point.y);
        CGFloat x;
        if(point.x>160.f)
        {
            x=point.x-160.f;
        }
        else
        {
            x=160.f-point.x;
        }
        
        CGFloat y;
        if(point.y>208.f)
        {
            y=point.y-208.f;
        }
        else
        {
            y=208.f-point.y;
        }
        
        CGFloat zoom;
        if(x/160.f > y/208.f)
        {
            zoom=x/160.f*0.1;
        }
        else
        {
            zoom=y/208.f*0.1;
        }
        
        [_mapView setCenterCoordinate:_mapView.userLocation.coordinate animated:YES];
        MKCoordinateSpan span=MKCoordinateSpanMake(zoom,zoom);
        MKCoordinateRegion region=MKCoordinateRegionMake(_mapView.userLocation.coordinate, span);
        [_mapView setRegion:region animated:YES];//显示偏移与缩放动画效果
    }
}

#pragma mark- 反编码
- (void)VeivoReverseGeocodeLocation
{
    LSLOG(@"地理坐标信息: %@",_location);
    
    CLGeocoder* geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:_location completionHandler:^(NSArray* placemarks, NSError* error) {
        
        NSString* address=nil;
        NSString* city=nil;
        if (placemarks.count > 0)
        {
            for(CLPlacemark* placemark in placemarks)
            {
                LSLOG(@"\n name: %@\n thoroughfare: %@\n subThoroughfare: %@\n locality: %@\n subLocality: %@\n administrativeArea: %@\n subAdministrativeArea: %@\n",
                      placemark.name,
                      placemark.thoroughfare,
                      placemark.subThoroughfare,
                      placemark.locality,
                      placemark.subLocality,
                      placemark.administrativeArea,
                      placemark.subAdministrativeArea
                      );
                //摩托罗拉大厦
                //望京东路
                //1号
                //(null)
                //朝阳区
                //北京市
                //(null)
                
                city=(placemark.administrativeArea==nil?@"":placemark.administrativeArea);
                
                NSString* subLocality=nil;
                if(placemark.subLocality!=nil)
                {
                    subLocality=placemark.subLocality;
                }
                
                NSString* thoroughfare=nil;
                if(placemark.thoroughfare!=nil)
                {
                    thoroughfare=placemark.thoroughfare;
                }
                
                NSString* subThoroughfare=nil;
                if(placemark.subThoroughfare!=nil)
                {
                    if(![placemark.subThoroughfare isEqualToString:placemark.thoroughfare])
                    {
                        subThoroughfare=placemark.subThoroughfare;
                    }
                }
                
                NSMutableString* name=nil;
                if(placemark.name!=nil)
                {
                    name=[NSMutableString stringWithString:placemark.name];
                    if(subLocality!=nil)
                    {
                        NSRange range=[name rangeOfString:subLocality];
                        if(range.location!=NSNotFound)
                        {
                            [name deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
                        }
                    }
                    if(thoroughfare!=nil)
                    {
                        NSRange range=[name rangeOfString:thoroughfare];
                        if(range.location!=NSNotFound)
                        {
                            [name deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
                        }
                    }
                    if(subThoroughfare!=nil)
                    {
                        NSRange range=[name rangeOfString:subThoroughfare];
                        if(range.location!=NSNotFound)
                        {
                            [name deleteCharactersInRange:NSMakeRange(0, range.location+range.length)];
                        }
                    }
                }
                
                address=[NSString stringWithFormat:@"%@%@%@%@",
                         subLocality==nil?@"":subLocality,
                         thoroughfare==nil?@"":thoroughfare,
                         subThoroughfare==nil?@"":subThoroughfare,
                         name==nil?@"":name
                         ];
            }
        }
        else if (error == nil && [placemarks count] == 0)
        {
            LSLOG(@"未查询到结果");
            address=@"未查询到结果";
        }
        else if (error != nil)
        {
            LSLOG(@"反编码失败: %@",error);
            address=@"查询失败";
        }
        else
        {
            address=@"未知的执行路径";
        }
        
        LSLOG(@"反编译地址: %@",address);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if([[_mapView.annotations objectAtIndex:0] isKindOfClass:[MKUserLocation class]] || [[_mapView.annotations objectAtIndex:1] isKindOfClass:[MKUserLocation class]])
            {
                MKUserLocation* userLocation=nil;
                if([[_mapView.annotations objectAtIndex:0] isKindOfClass:[MKUserLocation class]])
                {
                    userLocation=[_mapView.annotations objectAtIndex:0];//获取根注释
                }
                else if([[_mapView.annotations objectAtIndex:1] isKindOfClass:[MKUserLocation class]])
                {
                    userLocation=[_mapView.annotations objectAtIndex:1];//获取根注释
                }
                userLocation.title=address;
                [_mapView selectAnnotation:userLocation animated:YES];//选择根注释
            }
            else if([[_mapView.annotations objectAtIndex:0] isKindOfClass:[LSRootAnnotation class]] || [[_mapView.annotations objectAtIndex:1] isKindOfClass:[LSRootAnnotation class]])
            {
                LSRootAnnotation* rootAnnotation=nil;
                if([[_mapView.annotations objectAtIndex:0] isKindOfClass:[LSRootAnnotation class]])
                {
                    rootAnnotation=[_mapView.annotations objectAtIndex:0];//获取根注释
                }
                else if([[_mapView.annotations objectAtIndex:1] isKindOfClass:[LSRootAnnotation class]])
                {
                    rootAnnotation=[_mapView.annotations objectAtIndex:1];//获取根注释
                }
                rootAnnotation.title=address;
                [_mapView selectAnnotation:rootAnnotation animated:YES];//选择根注释
            }
            
            [self performSelector:@selector(showMovieInfo) withObject:nil afterDelay:2];
        });
    }];
    
    [geocoder release];
}
//最终总要显示影院
- (void)showMovieInfo
{
    LSCinemaAnnotation* cinemaAnnotation=nil;
    for(int i=0;i<_mapView.annotations.count;i++)
    {
        if([[_mapView.annotations objectAtIndex:i] isKindOfClass:[LSCinemaAnnotation class]])
        {
            cinemaAnnotation=[_mapView.annotations objectAtIndex:i];
        }
    }
    if(cinemaAnnotation==nil)
    {
        return;
    }
    
    CGPoint point=[_mapView convertCoordinate:cinemaAnnotation.coordinate toPointToView:_mapView];
    LSLOG(@"%f,%f",point.x,point.y);

    if(point.x>=50.f && point.y>=105.f && point.x<=270.f && point.y<=414.f)
    {
        [_mapView selectAnnotation:cinemaAnnotation animated:YES];
        if(_isAdapt)
        {
            _isAdapt=NO;
        }
    }
    else if(_isAdapt)
    {
        _isAnnotation=YES;
        [_mapView selectAnnotation:cinemaAnnotation animated:YES];
        _isAdapt=NO;
    }
    
    _isCanShowRootAnnotation=YES;
}

#pragma mark- 按钮的单击方法
- (void)buttonClick:(UIButton*)sender
{
    [LSAlertView showWithTag:0 title:nil message:@"跳出软件去查看路线？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}

#pragma mark- UIAlertView的委托方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex!=alertView.cancelButtonIndex)
    {
        if ([LSiOSVersion floatValue]<6.0)
        {
            NSString* encodeURL = [[NSString stringWithFormat:@"http://ditu.google.com/maps?saddr=%.6lf,%.6lf&daddr=%.6lf,%.6lf",_location.coordinate.latitude, _location.coordinate.longitude, _cinema.latitude, _cinema.longitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:encodeURL]];
        }
        else
        {
            MKPlacemark* myPlacemark = [[MKPlacemark alloc] initWithCoordinate:_location.coordinate addressDictionary:nil];
            MKMapItem* currentLocation = [[MKMapItem alloc] initWithPlacemark:myPlacemark];
            [myPlacemark release];
            currentLocation.name = @"我的位置";
            
            MKPlacemark* toPlacemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(_cinema.latitude, _cinema.longitude) addressDictionary:nil];
            MKMapItem* toLocation = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
            [toPlacemark release];
            toLocation.name = _cinema.cinemaName;
            
            NSArray *items = [[NSArray alloc] initWithObjects:currentLocation, toLocation, nil];
            [currentLocation release];
            [toLocation release];
            
            [MKMapItem openMapsWithItems:items
                           launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:  MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects: MKLaunchOptionsDirectionsModeKey,  MKLaunchOptionsShowsTrafficKey, nil]]];
            
            [items release];
        }
    }
}

@end
