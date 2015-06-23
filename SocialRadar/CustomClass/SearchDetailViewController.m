//
//  SearchDetailViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 02/07/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "NearByLocation.h"
#import "Location.h"
#import "AppDelegate.h"
#import "Common_IPhone.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Base64Image.h"
#import  "JSON.h"
#import "User.h"
#import "CLXURLConnection.h"

@interface SearchDetailViewController ()

@end

@implementation SearchDetailViewController
@synthesize locationObj,boolGoogle_Local;
@synthesize hybridCheckBox,location;

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
	// Do any additional setup after loading the view.
    
    
    self.title = locationObj.locationName;
    
    
    self.navigationItem.hidesBackButton = YES;
    
    UIImage* buttonImage1 = [UIImage imageNamed:@"back_btn.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
    [leftButton setImage:buttonImage1 forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=back_btn;
    [back_btn release];
    
    ////
    UIImage* buttonImage2 = nil;
    
    if (!location.IsFavorite)
    {
        buttonImage2 = [UIImage imageNamed:@"favorite_icn.png"];
        hybridCheckBox = NO;
    }else
    {
        buttonImage2 = [UIImage imageNamed:@"favorited_icn.png"];
        hybridCheckBox = YES;
        
    }
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame= CGRectMake(0, 0,buttonImage2.size.width, buttonImage2.size.height);
//    [rightButton setImage:buttonImage2 forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(favoriteTarget:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem=right_btn;
//    [right_btn release];
    
}

-(void)backTarget:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewDidAppear:(BOOL)animated
{
    if (self.boolGoogle_Local)
    {
        User *userData = appDelegate.appdelegateUser;
        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        [localDoct setValue:locationObj.latitude forKey:@"Latitude"];
        [localDoct setValue:locationObj.logitude forKey:@"longitude"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
        
        [appDelegate startAnimatingIndicatorView];
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getupdateResponse:);
        [temp postParseInfoWithUrlPath:KGetLocationDetail WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];

    }else
    {
        // comming data from google
        
//        locationObj.locationName
        [appDelegate startAnimatingIndicatorView];
        searchLocationName_lbl.text = locationObj.locationName;
       // search_lbl.text = @"0";
        searchTotalStrike_lbl.text = [NSString stringWithFormat:@"%i",0] ;
        searchTotalStorm_lbl.text = [NSString stringWithFormat:@"%i",0];
        liveFeeds_Male_lbl.text = [NSString stringWithFormat:@"%i (%i)",0,0];
        liveFeeds_Female_lbl.text = [NSString stringWithFormat:@"%i (%i)",0,0];
        searchAvgAge_lbl.text = @"0";
   
        searchLocationImageView.image = [UIImage imageNamed:@"no_image_location.png"];

        
       // NSLog(@" PHOT Name s%@",locationObj.photos_Refrence);
        
        
        if ([locationObj.photos_Refrence isEqualToString:@""]||locationObj.photos_Refrence==nil)
        {
            searchLocationImageView.image = [UIImage imageNamed:@"no_image_location.png"];
            [appDelegate stopAnimatingIndicatorView];
        }
        else
        {
           /* //Uncomment this when use google API for showing search result
            NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=%@&sensor=false&key=AIzaSyAfXbpScWudV9n79teEzazPNkhqGZjjVJA",locationObj.photos_Refrence]];
            [searchLocationImageView setImageWithURL:myURL];*/
          
            //Comment out below if not using Foursquare for showing search result
            // Load images async
            dispatch_queue_t queue = dispatch_queue_create("com.app.task",NULL);
            dispatch_queue_t main = dispatch_get_main_queue();
            dispatch_async(queue, ^{NSString *ImageURL = [[NSString alloc] initWithData:[UIImage base64DataFromString:locationObj.photos_Refrence] encoding:NSUTF8StringEncoding];
            NSURL *url = [NSURL URLWithString:ImageURL];
            UIImage *backgroundImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                dispatch_async(main, ^{searchLocationImageView.image = backgroundImage;
                    [appDelegate stopAnimatingIndicatorView];
                });
            });
            
        }
        
        if ([locationObj.contact_Refrence isEqualToString:@""]||locationObj.contact_Refrence==nil)
        {
            searchLocationPhone_lbl.text = @"";
            searchEmailAddress_lbl.text = @"";
        }
        else
        {
          /* //Uncomment this when use google API for showing search result
           NSURL *myURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=AIzaSyAfXbpScWudV9n79teEzazPNkhqGZjjVJA",locationObj.contact_Refrence]];
            //[ img setImageWithURL:myURL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL1
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:60];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
            
            
            //Comment out below if not using Foursquare for showing search result
            NSData *phoneData=[UIImage base64DataFromString:locationObj.contact_Refrence];
            NSString *decodedString = [[NSString alloc] initWithData:phoneData encoding:NSUTF8StringEncoding];
            searchLocationPhone_lbl.text = decodedString;
            
            if ([searchLocationPhone_lbl.text length] > 0)
            {
                //Adjusting the phone number label width
//                CGSize textSize = [searchLocationPhone_lbl.text sizeWithFont:[searchLocationPhone_lbl font] forWidth:searchLocationPhone_lbl.bounds.size.width lineBreakMode:UILineBreakModeWordWrap];
                
                // DAJ 20150622 replace depricated sizeWithFont
                CGRect textRect = [searchLocationPhone_lbl.text  boundingRectWithSize:searchLocationPhone_lbl.frame.size  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:searchLocationPhone_lbl.font} context:nil];
                CGSize textSize = textRect.size;
                
                phone_outlet.frame=CGRectMake(phone_outlet.frame.origin.x,phone_outlet.frame.origin.y, textSize.width, phone_outlet.frame.size.height);
                searchLocationPhone_lbl.frame=CGRectMake(searchLocationPhone_lbl.frame.origin.x,searchLocationPhone_lbl.frame.origin.y, textSize.width, searchLocationPhone_lbl.frame.size.height);
                
            }
        }
    }
}

#pragma mark NSURLCONNECTIONDELEGATE

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [responseData release];
    [connection release];
    //[textView setString:@"Unable to fetch data"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *txt = [[[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding] autorelease];
    NSString *dicstr=txt ;
    NSDictionary *jsonObject = [dicstr JSONValue];
    
    dataarray=[jsonObject valueForKey:@"result"];
    
    
    //    emailAddress_Outlet.text=[dataarray valueForKey:@"website"];
    
        
    searchEmailAddress_lbl.text = @"";
    searchLocationPhone_lbl.text = [dataarray valueForKey:@"formatted_phone_number"];
    if ([searchLocationPhone_lbl.text length] > 0)
    {
        //Adjusting the phone number label width
//        CGSize textSize = [searchLocationPhone_lbl.text sizeWithFont:[searchLocationPhone_lbl font] forWidth:searchLocationPhone_lbl.bounds.size.width lineBreakMode:UILineBreakModeWordWrap];

        // DAJ 20150622 replace depricated sizeWithFont
        CGRect textRect = [searchLocationPhone_lbl.text  boundingRectWithSize:searchLocationPhone_lbl.frame.size  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:searchLocationPhone_lbl.font} context:nil];
        CGSize textSize = textRect.size;
        
        phone_outlet.frame=CGRectMake(phone_outlet.frame.origin.x,phone_outlet.frame.origin.y, textSize.width, phone_outlet.frame.size.height);
        searchLocationPhone_lbl.frame=CGRectMake(searchLocationPhone_lbl.frame.origin.x,searchLocationPhone_lbl.frame.origin.y, textSize.width, searchLocationPhone_lbl.frame.size.height);
        
    }
}

#pragma mark favourite unfavourite

-(void)favoriteTarget:(id)sender
{
    // set BOOL for Fav or unFav
    
    // UIButton *but = (UIButton*)sender;
    self.navigationItem.rightBarButtonItem = nil;
    
    hybridCheckBox = !hybridCheckBox;
    
    if (hybridCheckBox == NO)
    {
        
        UIImage* buttonImage1 = [UIImage imageNamed:@"favorite_icn.png"];//USEAV
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
        [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(favoriteTarget:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=back_btn;
        [back_btn release];
        
        User *usersData = appDelegate.appdelegateUser;
        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        [localDoct setValue:[NSString stringWithFormat:@"%i",location.LocationId] forKey:@"LocationId"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",usersData.UserId] forKey:@"UserId"];
        [localDoct setValue:[NSNumber numberWithBool:FALSE] forKey:@"IsFavorite"];
        [appDelegate startAnimatingIndicatorView];
        
        
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getFavResponse:);
        [temp postParseInfoWithUrlPath:KUnFavoriteLocation WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
        
    }
    else
    {
        
        
        UIImage* buttonImage1 = [UIImage imageNamed:@"favorited_icn.png"];//favorited_icn.png
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
        [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(favoriteTarget:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=back_btn;
        [back_btn release];
        
        User *usersData = appDelegate.appdelegateUser;
        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        [localDoct setValue:[NSString stringWithFormat:@"%i",location.LocationId] forKey:@"LocationId"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",usersData.UserId] forKey:@"UserId"];
        [localDoct setValue:[NSNumber numberWithBool:TRUE] forKey:@"IsFavorite"];
        
        [appDelegate startAnimatingIndicatorView];
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getUnFavResponse:);
        [temp postParseInfoWithUrlPath:KSaveAsFavoriteLocation WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
        
    }
    
    
    
}



#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response{
    
     //UIImage* buttonImage1 = nil;
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
//        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//        return;
    }
    else
    {
        Location *locationShow = [[Location alloc] initWithNode:[response mutableCopy]];
//        if (!locationShow.IsFavorite) {
//            buttonImage1 = [UIImage imageNamed:@"favorite_icn.png"];
//            hybridCheckBox = NO;
//        }
//        else
//        {
//            buttonImage1 = [UIImage imageNamed:@"favorited_icn.png"];
//            hybridCheckBox = YES;
//        }
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
//        [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
//        [rightButton addTarget:self action:@selector(favoriteTarget:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        self.navigationItem.rightBarButtonItem=back_btn;
//        [back_btn release];
        
        searchLocationName_lbl.text = locationShow.LocationName;
        search_lbl.text = [self giveStrikeSymbolOnBasisOfStrike:locationShow.TotalStrike];;
        searchTotalStrike_lbl.text = [NSString stringWithFormat:@"%i",locationShow.TotalStrike] ;
        searchTotalStorm_lbl.text = [NSString stringWithFormat:@"%i",locationShow.TotalStromCount];
        liveFeeds_Male_lbl.text = [NSString stringWithFormat:@"%i (%i)",locationShow.TotalMale,locationShow.AverageMale];
        liveFeeds_Female_lbl.text = [NSString stringWithFormat:@"%i (%i)",locationShow.TotalFemale,locationShow.AverageFemale];
        searchAvgAge_lbl.text = [NSString stringWithFormat:@"%i",locationShow.AverageAge];
        searchLargestStorm_lbl.text  = [self giveStrikeSymbolOnBasisOfStrike:locationShow.LargestStrikeCount];
        if (locationShow.LargestStrikeCount < 20) {
             searchDateAndTimeLargestStorm_lbl.text = @"";
             
        }
        else
        {
            
            searchDateAndTimeLargestStorm_lbl.text = [NSString stringWithFormat:@"%@ %i strike(s)",locationShow.LargestStrikeCreatedDate,locationShow.LargestStrikeCount];
        }

        
        
        
        
        
        if ([locationShow.Photo isEqualToString:@""])
        {
            searchLocationImageView.image = [UIImage imageNamed:@"no_image_location.png"];
            [appDelegate stopAnimatingIndicatorView];
        }
        else
        {
           /* 
            //Uncomment this when use google API for showing search result
            NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=%@&sensor=false&key=AIzaSyAfXbpScWudV9n79teEzazPNkhqGZjjVJA",locationShow.Photo]];
            [searchLocationImageView setImageWithURL:myURL];*/
            
            
            //Comment out below if not using Foursquare for showing search result
           /* NSString *ImageURL = [[NSString alloc] initWithData:[UIImage base64DataFromString:locationObj.photos_Refrence] encoding:NSUTF8StringEncoding];
             NSData *imageData = [[NSData alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]]];
             searchLocationImageView.image = [UIImage imageWithData:imageData];*/
            
            dispatch_queue_t queue = dispatch_queue_create("com.app.task",NULL);
            dispatch_queue_t main = dispatch_get_main_queue();
            dispatch_async(queue, ^{
                NSString *ImageURL = [[NSString alloc] initWithData:[UIImage base64DataFromString:locationObj.photos_Refrence] encoding:NSUTF8StringEncoding];
                NSURL *url = [NSURL URLWithString:ImageURL];
                UIImage *backgroundImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                dispatch_async(main, ^{
                    searchLocationImageView.image = backgroundImage;
                    [appDelegate stopAnimatingIndicatorView];
                });
            });
        }
        
        if ([locationShow.LocationAddress isEqualToString:@""])
        {
            searchLocationPhone_lbl.text = @"";
            searchEmailAddress_lbl.text = @"";
        }
        else
        {
           /* //Uncomment this when use google API for showing search result
            NSURL *myURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=AIzaSyAfXbpScWudV9n79teEzazPNkhqGZjjVJA",locationShow.LocationAddress]];
            //[ img setImageWithURL:myURL];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL1
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:60];
            [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
            
            
            //Comment out below if not using Foursquare for showing search result
             NSData *phoneData=[UIImage base64DataFromString:locationObj.contact_Refrence];
             NSString *decodedString = [[NSString alloc] initWithData:phoneData encoding:NSUTF8StringEncoding];
             searchLocationPhone_lbl.text = decodedString;
             
             if ([searchLocationPhone_lbl.text length] > 0)
             {
             //Adjusting the phone number label width
//             CGSize textSize = [searchLocationPhone_lbl.text sizeWithFont:[searchLocationPhone_lbl font] forWidth:searchLocationPhone_lbl.bounds.size.width lineBreakMode:UILineBreakModeWordWrap];

             // DAJ 20150622 replace depricated sizeWithFont
             CGRect textRect = [searchLocationPhone_lbl.text  boundingRectWithSize:searchLocationPhone_lbl.frame.size  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:searchLocationPhone_lbl.font} context:nil];
             CGSize textSize = textRect.size;
                 
                 
                 
             phone_outlet.frame=CGRectMake(phone_outlet.frame.origin.x,phone_outlet.frame.origin.y, textSize.width, phone_outlet.frame.size.height);
             searchLocationPhone_lbl.frame=CGRectMake(searchLocationPhone_lbl.frame.origin.x,searchLocationPhone_lbl.frame.origin.y, textSize.width, searchLocationPhone_lbl.frame.size.height);
             
             }
        }
    }
}

-(void)getFavResponse:(NSDictionary*)response
{
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:@"Unfavorited  successfully" tittle:nil];
        return;
    }
    else
    {
        //[appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        [appDelegate showAlertMessage:@"Unfavorited  successfully" tittle:nil];
    }
    
    
}

-(void)getUnFavResponse:(NSDictionary*)response
{
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:@"Favorited successfully" tittle:nil];
        return;
    }
    else
    {
        //[appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        
        [appDelegate showAlertMessage:@"Favorited successfully" tittle:nil];
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
    NSMutableString *strgStrikeSymbol  = [[NSMutableString alloc] init];
    
    if (intStrike <= 20) {
        
        [strgStrikeSymbol setString:@""];
    }else if (intStrike <= 85)
    {
        [strgStrikeSymbol setString:@"EF0"];
        
    }else if (intStrike <= 110)
    {
        [strgStrikeSymbol setString:@"EF1"];
        
    }else if (intStrike <= 135)
    {
        [strgStrikeSymbol setString:@"EF2"];
        
    }else if (intStrike <= 165)
    {
        [strgStrikeSymbol setString:@"EF3"];
        
    }else if (intStrike <= 200)
    {
        [strgStrikeSymbol setString:@"EF4"];
        
    }else if (intStrike <= 299)
    {
        [strgStrikeSymbol setString:@"EF5"];
        
    }else if (intStrike > 300)
    {
        [strgStrikeSymbol setString:@"EF6"];
        
    }

    /*
    if (intStrike <= 5)
    {
        [strgStrikeSymbol setString:@"EF0"];
        
    }else if (intStrike <= 10)
    {
        [strgStrikeSymbol setString:@"EF1"];
        
    }else if (intStrike <= 15)
    {
        [strgStrikeSymbol setString:@"EF2"];
        
    }else if (intStrike <= 20)
    {
        [strgStrikeSymbol setString:@"EF3"];
        
    }else if (intStrike <= 50)
    {
        [strgStrikeSymbol setString:@"EF4"];
        
    }else if (intStrike <= 150)
    {
        [strgStrikeSymbol setString:@"EF5"];
        
    }else if (intStrike >= 250)
    {
        [strgStrikeSymbol setString:@"EF6"];
        
    }
    
    */
    return strgStrikeSymbol;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [searchLocationName_lbl release];
    [search_lbl release];
    [searchTotalStrike_lbl release];
    [searchTotalStorm_lbl release];
    [searchLargestStorm_lbl release];
    [searchDateAndTimeLargestStorm_lbl release];
    [liveFeeds_Male_lbl release];
    [liveFeeds_Female_lbl release];
    [searchAvgAge_lbl release];
    [searchLocationPhone_lbl release];
    [searchEmailAddress_lbl release];
    [searchLocationImageView release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [searchLocationName_lbl release];
    searchLocationName_lbl = nil;
    [search_lbl release];
    search_lbl = nil;
    [searchTotalStrike_lbl release];
    searchTotalStrike_lbl = nil;
    [searchTotalStorm_lbl release];
    searchTotalStorm_lbl = nil;
    [searchLargestStorm_lbl release];
    searchLargestStorm_lbl = nil;
    [searchDateAndTimeLargestStorm_lbl release];
    searchDateAndTimeLargestStorm_lbl = nil;
    [liveFeeds_Male_lbl release];
    liveFeeds_Male_lbl = nil;
    [liveFeeds_Female_lbl release];
    liveFeeds_Female_lbl = nil;
    [searchAvgAge_lbl release];
    searchAvgAge_lbl = nil;
    [searchLocationPhone_lbl release];
    searchLocationPhone_lbl = nil;
    [searchEmailAddress_lbl release];
    searchEmailAddress_lbl = nil;
    [searchLocationImageView release];
    searchLocationImageView = nil;
    [super viewDidUnload];
}

- (IBAction)searchChaseitAction:(id)sender
{
    
    CLLocation *myLocation = appDelegate.currentlocation;
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    
    
    CLLocationCoordinate2D destination = { [locationObj.latitude floatValue],[locationObj.logitude floatValue]};
    
    NSMutableString *googleAppleMapsURLString = [[NSMutableString alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0 )
    {
        [googleAppleMapsURLString setString:[NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",locationCoordinate.latitude, locationCoordinate.longitude, destination.latitude, destination.longitude] ];
        
    }
    else
    {
        //https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
        //[googleAppleMapsURLString setString:[NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=%1.6f,%1.6f",locationCoordinate.latitude, locationCoordinate.longitude, destination.latitude, destination.longitude]];
        [googleAppleMapsURLString setString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",locationCoordinate.latitude, locationCoordinate.longitude, destination.latitude, destination.longitude]];
        
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleAppleMapsURLString]];
    
    
    
}

#pragma mark make a Phone call
-(IBAction)makeCall:(id)sender
{
    BOOL canCall = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",searchLocationPhone_lbl.text] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    if (canCall)
    {
        if ([searchLocationPhone_lbl.text length]>0)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",searchLocationPhone_lbl.text] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        }
    }
    else
    {
        [appDelegate showAlertMessage:@"Phone calling not exist" tittle:nil];
    }
    
    
}
@end
