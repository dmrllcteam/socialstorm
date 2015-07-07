   //
//  HomeViewController.m
//  SocialRadar
//
//  Created by RRINNOVATION on 13/05/13.
//  Copyright (c) 2013 RRINNOVATION LLC. All rights reserved.
//

#import "Globals.h"
#import "HomeViewController.h"
#import "AddressAnnotation.h"
#import "Common_IPhone.h"
#import "HallOfFrameViewController.h"
#import "SearchViewController.h"
#import "AppDelegate.h"
#import "CalloutMapAnnotationView.h"
#import "CalloutMapAnnotation.h"
#import "CustomCallOutButton.h"
#import "LocationDetailViewController.h"
#import "User.h"
#import "NearByLocationViewControlerViewController.h"
#import "Location.h"
#import "MKAnnotationView+Rotate.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"
#import "UIImage+Base64Image.h"
#import "CLXURLConnection.h"


#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height-568)?NO:YES)

@interface HomeViewController ()
{
    NSMutableDictionary* pinAnnotationView;
}

@end

@implementation HomeViewController
@synthesize mylocation,mapViewHome;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        
        
       
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerStateChange:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    pinAnnotationView = [NSMutableDictionary new];
    mylocation=[[Location alloc] init];
    
    locationManager = [[CLLocationManager alloc] init];         // initalize locationManger instance
    [locationManager setDelegate:self];
 // DAJ 20150620 new location services check to see if IOS 8 gaurd against unkown selector in IOS 7
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) // check os for selector responce
    {
        [locationManager requestWhenInUseAuthorization];        // request autherzation only when in use
//        [locationManager requestAlwaysAuthorization];         // request autherzation when running in background
    }

//[loationManager ]

    [locationManager startUpdatingLocation];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
 
    
    [mapViewHome setShowsUserLocation:YES];
    isFromHomeView = YES;
    
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    lighteningImgView.hidden=true;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setStringForLabel:) name:@"SETLABEL" object:nil];
        
    UIImage* buttonImage1 = recordsIconImg;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
    [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(recordsTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=back_btn;
    [back_btn release];
  
   UIButton *leftNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
   leftNavBarButton.frame = CGRectMake(0, 0,searchImg.size.width, searchImg.size.height);
   [leftNavBarButton setImage:searchImg forState:UIControlStateNormal];
   [leftNavBarButton addTarget:self action:@selector(searchTarget:) forControlEvents:UIControlEventTouchUpInside];
   UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
   self.navigationItem.leftBarButtonItem=leftBarButton;
   [leftBarButton release];
    
    [self setTheMapView];
    
}
-(void)UpdateUserStrikeInfo
{
  
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp getParseInfoWithUrlPath:KGetLocationListWithStrikeCountAndTotalStrom WithSelector:selector callerClass:self parameterDic:nil showloader:NO];

  
}


-(void)setTheMapView
{
    CLLocation *currentLocations = [locationManager location];
    
    // showing only 20 miles area
    
    double miles = 20.0;
    double scalingFactor = ABS( (cos(2 * M_PI * currentLocations.coordinate.latitude / 360.0) ));
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = currentLocations.coordinate;
   
    [mapViewHome setRegion:region animated:YES];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    
    if ([[userDefault valueForKey:checkMapStyle] boolValue])
    {
        [mapViewHome setMapType:MKMapTypeHybrid];
        
    }else
    {
        [mapViewHome setMapType:MKMapTypeStandard];
    }
    

    isFromHomeView = YES;
    mapViewHome.delegate=self;

  
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp getParseInfoWithUrlPath:KGetLocationListWithStrikeCountAndTotalStrom WithSelector:selector callerClass:self parameterDic:nil showloader:NO];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:120
                                             target:self
                                           selector:@selector(UpdateUserStrikeInfo)
                                           userInfo:nil
                                            repeats:YES];

    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }

    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:homeTittle_IMG forBarMetrics:UIBarMetricsDefault];
    
}


-(void)viewWillDisappear:(BOOL)animated
{
     [self.navigationController.navigationBar setBackgroundImage:navigationImg forBarMetrics:UIBarMetricsDefault];
}

-(void)setStringForLabel:(NSNotification*)sender
{
    
    [appDelegate stopAnimatingIndicatorView];
    isFromHomeView = NO;
    

    loaderView.hidden = NO;
    
    // code for navigation
    for(UIViewController *vc in [self.navigationController viewControllers])
    {
        if([vc isKindOfClass:[HomeViewController class]])
        {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
    
   // darkHideView.hidden = NO;
    CLLocation *currentLocations = mapViewHome.userLocation.location;
    
   
    
    double miles = 20.0;
    double scalingFactor = ABS( (cos(2 * M_PI * currentLocations.coordinate.latitude / 360.0) ));
    //double scalingFactor = ABS( (cos(2 * M_PI * -33.8678500 / 360.0) ));//comment todo
    MKCoordinateSpan span;
    
       
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = currentLocations.coordinate;
   
    [mapViewHome setRegion:region animated:YES];
    
    NSString *filepath;
    
    if (!IS_IPHONE5) {
       filepath   =   [[NSBundle mainBundle] pathForResource:@"Iphone4" ofType:@"mp4"];
    }
    else
    {
        filepath   =   [[NSBundle mainBundle] pathForResource:@"Iphone5FLAT" ofType:@"mp4"];
      
    }
    
     
     NSURL    *fileURL    =   [NSURL fileURLWithPath:filepath];
    
      theMovie = [[MPMoviePlayerController alloc] initWithContentURL:fileURL];
	
    [[theMovie view] setFrame: [appDelegate.window bounds]];
   
    theMovie.controlStyle = MPMovieControlStyleNone;
    theMovie.backgroundView.alpha = 0.9;
    theMovie.view.alpha = 0.8;
    
	theMovie.scalingMode = MPMovieScalingModeAspectFill;
    [theMovie.backgroundView setBackgroundColor:[UIColor clearColor]];
    theMovie.view.backgroundColor = [UIColor clearColor];

	if(theMovie)
	{
        [theMovie play];
	}
	[appDelegate.window addSubview:[theMovie view]];
    
   // by ankur for clearing the background of video
        for(UIView* subV in theMovie.view.subviews) {
            subV.backgroundColor = [UIColor clearColor];
        }
    
    for(UIView* subV in theMovie.backgroundView.subviews) {
        subV.backgroundColor = [UIColor clearColor];
    }

[self performSelector:@selector(ChangeMoviePlayerBG) withObject:self afterDelay:3.5];

}


-(void)ChangeMoviePlayerBG
{
    theMovie.backgroundView.alpha = 0.1;
    theMovie.view.alpha = 0.1;

}
-(void)Strike
{
    //lighteningImgView.hidden=false;
    [loaderView addSubview:lighteningImgView];
    
    [self performSelector:@selector(Strike1) withObject:self afterDelay:.5];
    [self performSelector:@selector(Strike2) withObject:self afterDelay:.6];
    [self performSelector:@selector(Strike1) withObject:self afterDelay:.8];
    [self performSelector:@selector(Strike2) withObject:self afterDelay:1];
    [self performSelector:@selector(Strike1) withObject:self afterDelay:1.2];
    [self performSelector:@selector(Strike3) withObject:self afterDelay:1.3];
    
}

-(void)Strike3
{
    loaderView.hidden = YES;
    //darkHideView.hidden = YES;
    // here we navigate the screen of nearest all location with current location
    [appDelegate startAnimatingIndicatorView];
    [self performSelector:@selector(nearestLocationSelector) withObject:nil afterDelay:0.8];
    
}


-(void)Strike1
{
    lighteningImgView.hidden=true;
    
}

-(void)Strike2
{
    lighteningImgView.hidden=false;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [mapViewHome release];
    [darkHideView release];
    [super dealloc];
}

- (void)viewDidUnload
{
     //[timer invalidate];
    [mapViewHome release];
    mapViewHome = nil;
    [mylocation release];
    mylocation = nil;
    [darkHideView release];
    darkHideView = nil;
    [super viewDidUnload];
}

#pragma mark- Notification

-(void) moviePlayerStateChange:(NSNotification*) notify
{
    MPMoviePlayerController* movie = [notify object];
    
    [movie.view removeFromSuperview];
    [appDelegate startAnimatingIndicatorView];
    [self performSelector:@selector(nearestLocationSelector) withObject:nil afterDelay:0.1];
    
}

#pragma mark- Miscelleaneous


#pragma setAnnotationorder
-(void) setAnnotationInOrder
{
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [[pinAnnotationView allKeys] sortedArrayUsingDescriptors:sortDescriptors];
    
    for (int i=0; [sortedArray count] > i; i++)
    {
        MKAnnotationView* annV = [pinAnnotationView objectForKey:[sortedArray objectAtIndex:i]];
        [[[[[[[mapViewHome subviews] objectAtIndex:0] subviews] objectAtIndex:1] subviews] objectAtIndex:0] bringSubviewToFront:annV];
    }
}


-(void)getupdateResponse:(NSDictionary*)response
{
    [appDelegate stopAnimatingIndicatorView];
    
    //Remove the existing anootation
    // DAJ 20150623 Add globals class
    SSGlobals *globalSS = [[[SSGlobals alloc] init] autorelease];

    if ([[response objectForKey:kStatus] isKindOfClass:[NSNull class]])
    {
        CLLocation *myLocation = appDelegate.currentlocation;
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
       
        //comment todo This is Venues/Search
 //       [Foursquare2 venueSearchNearByLatitude:[NSNumber numberWithFloat:locationCoordinate.latitude] longitude:[NSNumber numberWithFloat:locationCoordinate.longitude] query:@("") limit:[NSNumber numberWithInt:50] intent:intentCheckin radius:globalSS.SSGVenueSearchRadius categoryId:nil callback:^(BOOL success, id result)
        [Foursquare2 venueSuggestCompletionByLatitude:[NSNumber numberWithFloat:locationCoordinate.latitude] longitude:[NSNumber numberWithFloat:locationCoordinate.longitude] near:@("") accuracyLL:@(1609.443) altitude:nil accuracyAlt:nil query:@("") limit:@(100) radius:@(1609.443) s:@(804.672) w:@(804.672) n:@(804.672) e:@(804.672) callback:^(BOOL success, id result)
      
        {
            if (success)
            {
            

                [self removeAllAnnotationExceptOfCurrentUser];
                
                if (arrayOfStrorm)
                {
                    [arrayOfStrorm release];
                    arrayOfStrorm = nil;
                }
                
                arrayOfStrorm = [[NSMutableArray alloc] init];
                NSDictionary *dic = result;
                NSMutableArray* venues = [dic valueForKeyPath:@"response.venues"];
                if ([venues  count] != 0)
                {
                    NSLog(@"%@",venues);

                    
                    for (NSMutableDictionary *FS_dict in venues)
                    {
                        NSString *venueid=[FS_dict valueForKey:@"id"];
                        if ([[[FS_dict objectForKey:@"hereNow"] valueForKey:@"count"] intValue]>0)
                        {
                            
                            
                            Location *location = [[Location alloc] initWithFourSquareNode:FS_dict];
                            if (![arrayOfStrorm containsObject:location])
                            {
                                [arrayOfStrorm addObject:location];
                            }
                            NSLog(@"location fs=%@",location.LocationName);
                            [location release];
                            NSLog(@"unmatched=%@",venueid);
                        }
                        
                        
                    }
                   
                     if ([arrayOfStrorm count] > 0)
                      {
                        [self addAnotation];
                     }
                }
                
                
                
            }
            
            else{
                NSLog(@"fetch location list failed-foursquare");

            }


        }];
        return;
    
    }
    
  
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"] )
    {
        return;
    }
    
    
    
    if (arrayOfStrorm)
    {
        [arrayOfStrorm release];
        arrayOfStrorm = nil;
    }
    
    arrayOfStrorm = [[NSMutableArray alloc] init];

    NSMutableArray *arrayOfLocationList = [response objectForKey:kLocationList];
    //here call the foursquare api to get list of trending venues and replace it with the SR venue with matched foursquare id, combing venues of FS and SR
    CLLocation *myLocation = appDelegate.currentlocation;
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    //comment todo
   
    [Foursquare2 venueSearchNearByLatitude:[NSNumber numberWithFloat:locationCoordinate.latitude] longitude:[NSNumber numberWithFloat:locationCoordinate.longitude] query:@("") limit:[NSNumber numberWithInt:50] intent:intentBrowse radius:globalSS.SSGVenueSearchRadius categoryId:nil callback:^(BOOL success, id result)


    {
        if (success)
        {
            [self removeAllAnnotationExceptOfCurrentUser]; // DAJ 20150707 commented out in original code uncomment causeing stacking of locations

          //  NSLog(@"response fs=%@",result);
            if ([arrayOfLocationList count] > 0)
            {
                NSDictionary *dic = result;
                NSMutableArray* venues = [dic valueForKeyPath:@"response.venues"];
                NSMutableArray *tempvenus = [[NSMutableArray alloc]initWithArray:venues];
                if ([venues  count]!=0)
                {
                    NSMutableDictionary *temp_FS_dict;
                    //Combining Foursquare and Social Radar Venues for showing it on Map
                    for (NSMutableDictionary *FS_dict in venues) {
                        NSString *venueid=[FS_dict valueForKey:@"id"];
                        temp_FS_dict=FS_dict;
                        for (NSMutableDictionary *SR_dict in arrayOfLocationList) {
                           
                            if (![[SR_dict valueForKey:@"FSLocationId"] isKindOfClass:[NSNull class]]) {
                                 NSLog(@"fslocationid=%@",[SR_dict valueForKey:@"FSLocationId"]);
                                
                                if ([[SR_dict valueForKey:@"FSLocationId"]isEqualToString:venueid]) {
                                    NSLog(@"matched=%@",[[SR_dict valueForKey:@"LocationId"] stringValue]);
                                    
                                    Location *location = [[Location alloc] initWithNode:SR_dict];
                                    if (![arrayOfStrorm containsObject:location]) {
                                        [arrayOfStrorm addObject:location];
                                    }
                                    NSLog(@"location sr=%@",location.LocationName);
                                    [location release];
                                    //break;
                                    [tempvenus removeObject:FS_dict];
                                    
                                }

                            }
                                                        
                           
                        
                        }
                    
                        
                    }
                    for (NSMutableDictionary *temp_FS_dict in tempvenus) {
                        if ([[[temp_FS_dict objectForKey:@"hereNow"] valueForKey:@"count"] intValue]>0)
                        {
                            Location *location = [[Location alloc] initWithFourSquareNode:temp_FS_dict];
                            if (![arrayOfStrorm containsObject:location]) {
                                [arrayOfStrorm addObject:location];
                            }
                            [location release];
                        }
                    
                    
                    }
     
                    
                    if ([arrayOfStrorm count]>0) {
                        [self addAnotation];
                    }
                    
                }
                else{
                    
                    for (int i =0; i< [arrayOfLocationList count]; i++)
                    {
                        Location *location = [[Location alloc] initWithNode:[arrayOfLocationList objectAtIndex:i]];
                        [arrayOfStrorm addObject:location];
                        [location release];
                    }
                    if ([arrayOfStrorm count]>0) {
                        [self addAnotation];
                    }
                }
                
            }
        }
        else
        {
            NSLog(@"fetch location list failed-foursquare");
        }
}];
    
   
    
}

- (void)removeAllAnnotationExceptOfCurrentUser {
    
    NSMutableArray *annForRemove = [[NSMutableArray alloc] initWithArray:self.mapViewHome.annotations];
    if ([self.mapViewHome.annotations.lastObject isKindOfClass:[MKUserLocation class]]) {
        [annForRemove removeObject:self.mapViewHome.annotations.lastObject];
    } else {
        for (id <MKAnnotation> annot_ in self.mapViewHome.annotations) {
            if ([annot_ isKindOfClass:[MKUserLocation class]] ) {
                [annForRemove removeObject:annot_];
                break;
            }
        }
    }
    
    [self.mapViewHome removeAnnotations:annForRemove];
}


-(void)nearestLocationSelector
{
    NSLog(@"network value=%d",[appDelegate connectedToNetwork]);
    if ([appDelegate connectedToNetwork]) {
        [appDelegate stopAnimatingIndicatorView];
        currentLocation = mapViewHome.userLocation.location;
        
        if ([mapViewHome showsUserLocation])
        {
            
            //here send the log and lat on another page
            NearByLocationViewControlerViewController *near = [[NearByLocationViewControlerViewController alloc] initWithNibName:KNearByLocationViewControlerViewController bundle:nil];
            near.currentLocationsProperty = currentLocation;
            [self.navigationController pushViewController:near animated:YES];
            [near release];
            
           
            
            
        }else
        {
            //show the alert view
            
        }
    }
    else{
       [appDelegate stopAnimatingIndicatorView]; 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Not Available" message:@"Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
}

-(void)addAnotation
{
    //37.534993,-122.305082
    CLLocationCoordinate2D locationCoordinate ;
    
    for (int i =0; i < [arrayOfStrorm count]; i++)
    {
        Location *locations = [arrayOfStrorm objectAtIndex:i];
        NSLog(@"Before sorting %d",locations.TotalStrike);
    }
    
    
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"TotalStrike" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [arrayOfStrorm sortedArrayUsingDescriptors:sortDescriptors];

    [arrayOfStrorm removeAllObjects];
    arrayOfStrorm=[sortedArray mutableCopy];
    for (int i =0; i< [arrayOfStrorm count]; i++)
    {
        Location *locations = [arrayOfStrorm objectAtIndex:i];
        NSLog(@"after sorting %d",locations.TotalStrike);
    }

    [pinAnnotationView removeAllObjects];
    for (int i =0; i< [arrayOfStrorm count]; i++)
    {
        Location *locations = [arrayOfStrorm objectAtIndex:i];
        locationCoordinate = CLLocationCoordinate2DMake( [locations.Latitude floatValue],[locations.longitude floatValue]);
                //locationCoordinate = CLLocationCoordinate2DMake( -33.8678500  ,151.2073200); //comment todo
                // NSLog(@" total Strikes %i",locations.LocationName);
        
        AddressAnnotation* ann = [[AddressAnnotation alloc] init];
        ann.coordinate = locationCoordinate;
        ann.strikeNo = locations.TotalStrike;
        ann.title = locations.LocationName;
        ann.location = locations;
        //[ann setValue:[NSString stringWithFormat:@"%i",i+100] forKey:@"envetsMyIDs"];
        
        [mapViewHome addAnnotation:ann];
    }
    

    
}


-(void)recordsTarget:(id)sender
{
   HallOfFrameViewController *hall = [[HallOfFrameViewController alloc] initWithNibName:kHallOfFrameViewController bundle:nil];
    
  //  HallOfFrameViewController *hall = [[HallOfFrameViewController alloc] i];
    [self.navigationController pushViewController:hall animated:YES];
    //_RELEASE(hall);
    
}

-(void)searchTarget:(id)sender
{
    SearchViewController *search = [[SearchViewController alloc] initWithNibName:kSearchViewController bundle:nil];
    [self.navigationController pushViewController:search animated:YES];
    [search release];
    
}

// DAJ code not executed
/*
-(void) bringCalloutInFront:(CalloutMapAnnotation*) ann
{
    for (id<MKAnnotation> annotation in mapViewHome.annotations)
    {
        MKAnnotationView* anView = [mapViewHome viewForAnnotation: ann];
        if (anView)
        {
            [mapViewHome bringSubviewToFront:anView];
        }
    }
}
*/
-(void)prepareAnnotationviewUser:(NSString*)username withObject:(Location*)looc WithTag:(NSInteger)tag withContentView:(UIView*)contentView
{
    
    UIImageView *imageViewBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blog.png"]];
//    UIImageView* imageViewBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 117.4, 85)];
   // [imageViewBackground setImage:[UIImage imageNamed:@"blog.png"]];
    

    [contentView addSubview:imageViewBackground];
   
    locTotalstrike = looc.TotalStrike;
    
    if (looc.TotalStrike >= 20)
    {
        
        UILabel  *userNameLabel        = [[UILabel alloc] initWithFrame:CGRectMake(4, 14, 117, 14)];
        userNameLabel.backgroundColor  = [UIColor clearColor];
        userNameLabel.opaque           = NO;
        userNameLabel.textColor        = [UIColor whiteColor];
        userNameLabel.font             = [UIFont boldSystemFontOfSize:14.0];
//        userNameLabel.textAlignment    = UITextAlignmentCenter;
        userNameLabel.textAlignment    = NSTextAlignmentCenter;     // DAJ UITextAlignmentCenter depracated

        userNameLabel.text =[NSString stringWithFormat:@"%@ STORM!",[self giveStrikeSymbolOnBasisOfStrike:looc.TotalStrike]];
        [contentView addSubview:userNameLabel];
        [userNameLabel release];
    }
    
    
    
   // UILabel  *infoLabel        = [[UILabel alloc] initWithFrame:CGRectMake(12, 25, 93.4, 14)];
    UILabel  *infoLabel        = nil;
    if (looc.TotalStrike >= 20)
    {
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 110, 14)];
         infoLabel.font             = [UIFont boldSystemFontOfSize:10.0];
    }else
    {
       infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 110, 17)];     // RAR This line changes establishment title text in Bubble
         infoLabel.font             = [UIFont boldSystemFontOfSize:14.0];
    }
    infoLabel.backgroundColor  = [UIColor clearColor];
    infoLabel.opaque           = NO;
    //infoLabel.numberOfLines    = 3;
    infoLabel.textColor        = [UIColor whiteColor];
   
    infoLabel.textAlignment    = NSTextAlignmentCenter;
    infoLabel.text             = [NSString stringWithFormat:@"%@",looc.LocationName];
    [contentView addSubview:infoLabel];
    [infoLabel release];
   
  //  UILabel  *strikeLabel        = [[UILabel alloc] initWithFrame:CGRectMake(12, 39, 93.4,14)];
    
    UILabel  *strikeLabel        = nil;
    if (looc.TotalStrike >= 20)
    {
        strikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 43, 93.4,14)];
        strikeLabel.font = [UIFont italicSystemFontOfSize:9.0];
    }else
    {
        strikeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 31, 93.4,14)];
        strikeLabel.font             = [UIFont italicSystemFontOfSize:12.0];
    }
    strikeLabel.backgroundColor  = [UIColor clearColor];
    strikeLabel.opaque           = NO;
    //strikeLabel.numberOfLines    = 3;
    strikeLabel.textColor        = [UIColor whiteColor];
    
    strikeLabel.textAlignment    = NSTextAlignmentCenter;
    strikeLabel.text = [NSString stringWithFormat:@"%i Strike(s)",looc.TotalStrike];
    [contentView addSubview:strikeLabel];
    [strikeLabel autorelease];
}

       

#pragma mark- Action Method

- (void)arrowBtnPressed:(id)sender
{
   LocationDetailViewController *locationDeatails = [[LocationDetailViewController alloc] initWithNibName:KLocationDetailViewController bundle:nil];
    locationDeatails.isFromHallOfFrame = NO;
    locationDeatails.locationObj = self.mylocation;
    [self.navigationController pushViewController:locationDeatails animated:YES];
    
    if (IS_IPHONE5) {
        
    } else {
        
    }
    
}

- (IBAction)navigationBttnAction:(id)sender
{
   currentLocation = mapViewHome.userLocation.location;
    double miles = 20.0;
    //double scalingFactor = ABS( (cos(2 * M_PI * -33.8678500   / 360.0) ));//comment todo
   double scalingFactor = ABS( (cos(2 * M_PI * currentLocation.coordinate.latitude / 360.0) ));
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = currentLocation.coordinate;
    //to be commented
    //region.center.latitude=-33.8678500  ;//comment todo
    //region.center.longitude=151.2073200;//comment todo
    // end
    [mapViewHome setRegion:region animated:YES];

}

#pragma mark- MapView Delegate

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    [self setAnnotationInOrder];
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
{

    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        ((MKUserLocation *)annotation).title = @"My Current Location";
        return nil;  //return nil to use default blue dot view
    }
    
    MKAnnotationView *pinView = nil; ;
    
    if([annotation isKindOfClass:[AddressAnnotation class]])
    {
 
        static NSString *defaultPinID = @"com.invasivecode.pin";
        pinView = (MKAnnotationView *)[mapViewHome dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
 //       if ( pinView == nil )  // DAJ put back into code was commented out 20150523
        {
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
        }

        AddressAnnotation* addAnn = (AddressAnnotation*)annotation;

        if (addAnn.strikeNo < 5)
        {
            //Green STrike
            //pinView.image = [UIImage imageNamed:@"storm_small.png"];//storm_small  //green_bubble.png
            UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green_bubble.png"]];
            [pinView setImgView:imgViewTemp];
            [imgViewTemp release];
            //[pinView performSelector:@selector(rotate) withObject:self afterDelay:0.2];
            
            CGRect rect = pinView.frame;
            rect.size.width = imgViewTemp.frame.size.width;
            rect.size.height  = imgViewTemp.frame.size.height;
            pinView.frame = rect;
        }
        else if (addAnn.strikeNo < 10)
        {
            //Green STrike
            //pinView.image = [UIImage imageNamed:@"storm_small.png"];//storm_small  //green_bubble.png
            UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yellow_bubble.png"]];
            [pinView setImgView:imgViewTemp];
            [imgViewTemp release];
            //[pinView performSelector:@selector(rotate) withObject:self afterDelay:0.2];
            
            CGRect rect = pinView.frame;
            rect.size.width = imgViewTemp.frame.size.width;
            rect.size.height  = imgViewTemp.frame.size.height;
            pinView.frame = rect;
        }
        else if (addAnn.strikeNo < 20)
        {
            //Green STrike
            //pinView.image = [UIImage imageNamed:@"storm_small.png"];//storm_small  //green_bubble.png
            UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_bubble.png"]];
            [pinView setImgView:imgViewTemp];
            [imgViewTemp release];
            //[pinView performSelector:@selector(rotate) withObject:self afterDelay:0.2];
            
            CGRect rect = pinView.frame;
            rect.size.width = imgViewTemp.frame.size.width;
            rect.size.height  = imgViewTemp.frame.size.height;
            pinView.frame = rect;
        }
        else if (addAnn.strikeNo <= 110)
        {
            //Green STrike
            //pinView.image = [UIImage imageNamed:@"storm_small.png"];//storm_small  //green_bubble.png
            UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"storm_small.png"]];
            [pinView setImgView:imgViewTemp];
            [imgViewTemp release];
            [pinView performSelector:@selector(rotate) withObject:self afterDelay:0.2];
            
            CGRect rect = pinView.frame;
            rect.size.width = imgViewTemp.frame.size.width;
            rect.size.height  = imgViewTemp.frame.size.height;
            pinView.frame = rect;
        }
        else if (addAnn.strikeNo <=165)
        {
         //Yellow Strike
          // pinView.image = [UIImage imageNamed:@"storm_mediun.png"];//storm_mediun//yellow_bubble.png
           UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"storm_mediun.png"]];
           [pinView setImgView:imgViewTemp];
           [imgViewTemp release];
            [pinView performSelector:@selector(rotate) withObject:self afterDelay:0.2];
            
            CGRect rect = pinView.frame;
            rect.size.width = imgViewTemp.frame.size.width;
            rect.size.height  = imgViewTemp.frame.size.height;
            pinView.frame = rect;
            
        }
        else if (addAnn.strikeNo <= 500)
        {
            //Red Strike
 //          pinView.image = [UIImage imageNamed:@"storm_large.png"];//red_bubble.png
           UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"storm_large.png"]];
          [pinView setImgView:imgViewTemp];
            [imgViewTemp release];
          [pinView performSelector:@selector(rotate) withObject:self afterDelay:0.2];
            
            CGRect rect = pinView.frame;
            rect.size.width = imgViewTemp.frame.size.width;
            rect.size.height  = imgViewTemp.frame.size.height;
            pinView.frame = rect;
            
        }
       else
        {
//            UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"storm_icn-568h@2x.png"]];
            UIImageView* imgViewTemp = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"storm_largeest.png"]];
            [pinView setImgView:imgViewTemp];
            [imgViewTemp release];
            [pinView performSelector:@selector(rotate) withObject:self afterDelay:0.2];
            
            CGRect rect = pinView.frame;
            rect.size.width = imgViewTemp.frame.size.width;
            rect.size.height  = imgViewTemp.frame.size.height;
            pinView.frame = rect;
        }
    

        Location* loc = [arrayOfStrorm lastObject];
        if (loc.TotalStrike == addAnn.strikeNo)
        {
            [self performSelector:@selector(setAnnotationInOrder) withObject:nil afterDelay:0.6];
        }
        
 //       [pinAnnotationView setObject:pinView forKey:[NSNumber numberWithInteger:addAnn.strikeNo]];
        
        return pinView;
        //as suggested by Squatch
    }

    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]])
    {
        CalloutMapAnnotationView *calloutuserAnnotationView = (CalloutMapAnnotationView *)[mapViewHome dequeueReusableAnnotationViewWithIdentifier:@"CalloutMapAnnotation"];
        if (!calloutuserAnnotationView) // DAJ 20150523 uncomment
       {
            CalloutMapAnnotation* callOutAnn = (CalloutMapAnnotation*)annotation;
            calloutuserAnnotationView = [[[CalloutMapAnnotationView alloc] initWithAnnotation:annotation
                                                                               reuseIdentifier:@"CalloutMapAnnotation"] autorelease];
			calloutuserAnnotationView.contentHeight = 74.0f;
            calloutuserAnnotationView.mapView = mapViewHome;
            [self prepareAnnotationviewUser:@"EF5 STORM!" withObject:callOutAnn.location WithTag:0  withContentView:calloutuserAnnotationView.contentView];
            
            CustomCallOutButton* callOutButton = [CustomCallOutButton buttonWithType:UIButtonTypeCustom];
            
           
                [callOutButton setFrame:CGRectMake(105,28,15,22.5)];
        
            
            [callOutButton setImage:[UIImage imageNamed:@"arrow_grey"] forState:UIControlStateNormal];
            callOutButton.tag = ((CalloutMapAnnotation*)annotation).tag;
            self.mylocation = callOutAnn.location;
            [callOutButton addTarget:self action:@selector(arrowBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arrowBtnPressed:)];
            
            gestureRecognizer.numberOfTapsRequired = 1;
            //Comment below line to roll back CR -7
            [calloutuserAnnotationView addGestureRecognizer:gestureRecognizer];   // DAJ uncomment out 20150523
            [calloutuserAnnotationView.contentView addSubview:callOutButton];     // DAJ uncomment same date
            
      }



        calloutuserAnnotationView.parentAnnotationView = selectedAnnotationView;

        
        return calloutuserAnnotationView;
   }
    

  
    return nil;
   
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
    if ([view.annotation isKindOfClass:[AddressAnnotation class]])
    {
        
        if (_calloutAnnotation == nil)
        {
            _calloutAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                                        andLongitude:view.annotation.coordinate.longitude];
            
        }
        else
        {
            _calloutAnnotation.latitude = view.annotation.coordinate.latitude;
            _calloutAnnotation.longitude = view.annotation.coordinate.longitude;
        }
        AddressAnnotation* addAnn = (AddressAnnotation*)view.annotation;
        _calloutAnnotation.location = addAnn.location;
        _calloutAnnotation.tag = view.tag;
        selectedAnnotationView = view;
        [mapViewHome addAnnotation:_calloutAnnotation];
        
    }
}

-(void) mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    if (_calloutAnnotation && [view.annotation isKindOfClass:[AddressAnnotation class]])
    {
        [mapViewHome removeAnnotation: _calloutAnnotation];
	}
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *) views
{
    [self performSelector:@selector(bringCalloutToFront:) withObject:views afterDelay:0.2]; // test original at .2
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if(error.code==kCLErrorDenied)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enable your Location Services" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void) bringCalloutToFront:(NSArray* ) views
{
    for (MKAnnotationView * annView in views)
    {
        if ([annView isKindOfClass:[CalloutMapAnnotationView class]])
        {
//            [[[[[[[mapViewHome subviews] objectAtIndex:0] subviews] objectAtIndex:1] subviews] objectAtIndex:0] bringSubviewToFront:annView];
            [[[[[mapViewHome subviews] objectAtIndex:0] subviews] objectAtIndex:1] bringSubviewToFront:annView];
        }
        
    }
}
/*
 Storm Level System – this is currently at the correct scale in the app
 EF0 (20-85 strikes)
 EF1 (86-110 strikes)
 EF2 (111-135 strikes)
 EF3 (136-165 strikes)
 EF4 (166-200 strikes)
 EF5 – (201-299 strikes)
 EF6 – (300+ strikes)
 Author:Sanjay
 */


-(NSMutableString *)giveStrikeSymbolOnBasisOfStrike:(int)intStrike
{
    NSMutableString *strgStrikeSymbol = [[[NSMutableString alloc] init] autorelease];
    
    if (intStrike < 20)
    {
        [strgStrikeSymbol setString:@""];
    }
    else if (intStrike <= 85)
    {
        [strgStrikeSymbol setString:@"EF0"];
        
    }
    else if (intStrike <= 110)
    {
        [strgStrikeSymbol setString:@"EF1"];
        
    }
    else if (intStrike <= 135)
    {
        [strgStrikeSymbol setString:@"EF2"];
        
    }
    else if (intStrike <= 165)
    {
        [strgStrikeSymbol setString:@"EF3"];
        
    }
    else if (intStrike <= 200)
    {
        [strgStrikeSymbol setString:@"EF4"];
        
    }
    else if (intStrike <= 299)
    {
        [strgStrikeSymbol setString:@"EF5"];
        
    }
    else if (intStrike > 300)
    {
        [strgStrikeSymbol setString:@"EF6"];
        
    }
    return strgStrikeSymbol;
}


-(NSString *)converToBase64:(NSString*)str
{
   // NSLog(@"before base 64=%@", str);
    NSString *base64String = nil;
    // NSData *data=[UIImage base64DataFromString:str];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    base64String=[UIImage base64forData:data];
   // NSLog(@"after base64=%@",base64String);
    
    return base64String;
}


@end
