//
//  LocationDetailViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 02/06/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import "LocationDetailViewController.h"
#import "Location.h"
#import "AppDelegate.h"
#import "Common_IPhone.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "JSON.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Base64Image.h"
#import "UIImageView+WebCache.h"
#import "CLXURLConnection.h"

@interface LocationDetailViewController ()

@end

@implementation LocationDetailViewController
@synthesize hybridCheckBox,locationObj;
@synthesize isFromHallOfFrame;

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
    
    //contactOverly_outlet.backgroundColor=[UIColor colorWithRed:105/255 green:123/255 blue:160/255 alpha:0.899999976158142];
    
    locationImageView.layer.cornerRadius=10.0;
    locationImageView.layer.borderWidth=2.0;
    //locationImageView.layer.borderColor=[[UIColor colorWithWhite:1.0 alpha:2] CGColor];
    locationImageView.layer.borderColor=[[UIColor clearColor] CGColor];
    
    self.navigationItem.hidesBackButton = YES;
    
    self.title = [NSString stringWithFormat:@"%@", self.locationObj.LocationName];
    
    strgStrikeSymbol = [[NSMutableString alloc] init];
    
    UIImage* buttonImage1 = nil;
    
    if (!locationObj.IsFavorite) {
        buttonImage1 = [UIImage imageNamed:@"favorite_icn.png"];
        hybridCheckBox = NO;
    }else
    {
        buttonImage1 = [UIImage imageNamed:@"favorited_icn.png"];
        hybridCheckBox = YES;

    }
    
    if (locationObj.LocationId==0) {
       self.navigationItem.rightBarButtonItem=nil;
    }
    else{
        
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
        [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(favoriteTarget:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=back_btn;
        [back_btn release];
    }
   
    
    UIImage* buttonImage2 = [UIImage imageNamed:@"back_btn.png"];
    UIButton *leftNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBarButton.frame = CGRectMake(0, 0,buttonImage2.size.width, buttonImage2.size.height);
    [leftNavBarButton setImage:buttonImage2 forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    [leftBarButton release];
    
        
//    {
//        Category = "<null>";
//        EmailId = "";
//        IsAutoStrikeOn = 0;
//        IsFavorite = 0;
//        Latitude = 28;
//        LocationAddress = "CnRpAAAAOHxxucBglKvZFutI3kFYa-NSqRSAAgg5SnjxsKkkWuuce7LNLWySCwee4w6P1YNL5FvZ6diQPNWC8kkQENgPpwQlqb32htjXgcOTuhCLZ6NbBfwGGK5qeORG2t4GckQ2MlCXwGvqrSDjMyfv_xC-gBIQnYPcUiGzCXeADErQtY0s8xoUy9FLtp6nMiWcck6WtG4LzrfLI-g";
//        LocationId = 0;
//        LocationList = "<null>";
//        LocationName = "Vatika City";
//        Message = "<null>";
//        PhoneNo = "";
//        Photo = "CnRoAAAAhHlT6zRQAGFsFOx3NbGyTZXaHO93c9-PWIK6sVCnArnG6_D7BR4q0KE6gOFQ4ZHAYsSX0xNX9k-_2nwUa-ksvmxek2CZgVfVty6zPt9w0GkjBO0qbFUZ5twV1KsTlQRf37rJPcIRXWVEoODvaEdmXhIQVjAvPso0OHISrNnwglEIVxoUai-y2Y4VTZEqCtYuomqLv8tTYNY";
//        Status = "<null>";
//        TotalStrike = 0;
//        TotalStrom = 2;
//        UserId = 0;
//        longitude = 77;
//    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
    User *userData = appDelegate.appdelegateUser;
//    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:locationObj.Latitude forKey:@"Latitude"];
    [localDoct setValue:locationObj.longitude forKey:@"longitude"];
    [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
    
    [appDelegate startAnimatingIndicatorView];
    
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp postParseInfoWithUrlPath:KGetLocationDetail WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
  
   
    
}

-(void)backTarget:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response{
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
       // [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
       // return;
        totalStrike_Outlet.text = [NSString stringWithFormat:@"%i",locationObj.TotalStrike] ;
        total_Storm.text = [NSString stringWithFormat:@"%i",0];
        liveFeeds_M_outlet.text = [NSString stringWithFormat:@"%i (%i)",0,0];
        liveFeeds_F_Outlet.text = [NSString stringWithFormat:@"%i (%i)",0,0];
        avgAge_Outlet.text = @"0";
        //locationImageView.image = [UIImage imageNamed:@"no_image_location.png"];
        phoneNumber_Outlet.text = @"";
        emailAddress_Outlet.text = @"";
        if (locationObj.FoursquareID.length>0) {
            
            if (locationObj.Photo!=nil)
            {
                /*NSString *ImageURL = [[NSString alloc] initWithData:[UIImage base64DataFromString:locationObj.Photo] encoding:NSUTF8StringEncoding];
                NSData *imageData = [[NSData alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]]];
                locationImageView.image = [UIImage imageWithData:imageData];*/
                
                UIImage* loadingImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no_image_location" ofType:@"png"]];
                
                
               // NSString *ImageURL = [[NSString alloc] initWithData:[UIImage base64DataFromString:locationObj.Photo] encoding:NSUTF8StringEncoding];
                
                [locationImageView setImageWithURL:[NSURL URLWithString:locationObj.Photo] placeholderImage:nil success:^(UIImage* img){
                    
                    [locationImageView setImage:img];
                    
                } failure:^(NSError* err){
                    
                    
                    [locationImageView setImage:loadingImage];
                }];

            }
            else{
              [Foursquare2 venueGetPhotos:locationObj.FoursquareID limit:[NSNumber numberWithInteger:1] offset:nil callback:^(BOOL success, id result) {
                    if (success) {
                        NSDictionary *resultDictionry= result;
                        NSArray *array=[[[resultDictionry objectForKey:@"response"] objectForKey:@"photos"]objectForKey:@"items"];
                        
                        if (array!=nil&&array.count) {
                            NSDictionary *imageDict=[array objectAtIndex:0];
                            
                            
                           // locationImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",[imageDict objectForKey:@"prefix"],@"300x300",[imageDict objectForKey:@"suffix"]]]]];
                            
                            UIImage* loadingImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no_image_location" ofType:@"png"]];
                            
                            [locationImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",[imageDict objectForKey:@"prefix"],@"300x300",[imageDict objectForKey:@"suffix"]]] placeholderImage:nil success:^(UIImage* img){
                                
                                [locationImageView setImage:img];
                                
                            } failure:^(NSError* err){
                                
                                
                                [locationImageView setImage:loadingImage];
                            }];
                         }
                        else {
                            locationImageView.image = [UIImage imageNamed:@"no_image_location.png"];
                        }
                    } else {
                        locationImageView.image = [UIImage imageNamed:@"no_image_location.png"];
                    }
                }];
            }
          

        }
        else
        {
            locationImageView.image = [UIImage imageNamed:@"no_image_location.png"];
        }
        
        if (locationObj.FoursquareID.length>0)
        {
           
            if (locationObj.LocationAddress!=nil)
            {
                
                NSData *phoneData=[UIImage base64DataFromString:locationObj.LocationAddress];
                NSString *decodedString = [[NSString alloc] initWithData:phoneData encoding:NSUTF8StringEncoding];
                phoneNumber_Outlet.text = decodedString;
                
                if ([phoneNumber_Outlet.text length] > 0)
                {
                    //Adjusting the phone number label width
// depricated  CGSize textSize = [phoneNumber_Outlet.text sizeWithFont:[phoneNumber_Outlet font] forWidth:phoneNumber_Outlet.bounds.size.width   lineBreakMode:NSLineBreakByWordWrapping];
                    
    // DAJ 20150622 replace depricated sizeWithFont
                    CGRect textRect = [phoneNumber_Outlet.text  boundingRectWithSize:phoneNumber_Outlet.frame.size  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:phoneNumber_Outlet.font} context:nil];
                    phone_outlet.frame=CGRectMake(phone_outlet.frame.origin.x,phone_outlet.frame.origin.y, textRect.size.width, phone_outlet.frame.size.height);
                    phoneNumber_Outlet.frame=CGRectMake(phoneNumber_Outlet.frame.origin.x,phoneNumber_Outlet.frame.origin.y, textRect.size.width, phoneNumber_Outlet.frame.size.height);
                    
                }
            }
            else{
                [Foursquare2 venueGetDetail:locationObj.FoursquareID callback:^(BOOL success, id result) {
                    if (success) {
                        
                        //setting the contact number
                        NSDictionary *dict=result;
                        if ([[[[dict objectForKey:@"response"] valueForKey:@"venue"] valueForKey:@"contact"] valueForKey:@"formattedPhone"]!=nil) {
                            phoneNumber_Outlet.text = [[[[dict objectForKey:@"response"] valueForKey:@"venue"] valueForKey:@"contact"] valueForKey:@"formattedPhone"];
                        }
                        else{
                            phoneNumber_Outlet.text = @"";
                        }
                        
                    }
                    else{
                        phoneNumber_Outlet.text = @"";
                    }
                    
                }];
            }
           
               
        }
        else{
             phoneNumber_Outlet.text = @"";
        }
        
        
        
               
    }
    else
    {
        locationShow = [[Location alloc] initWithNode:[response mutableCopy]];
        location_Outlet.text = locationShow.LocationName;
        [self giveStrikeSymbolOnBasisOfStrike:locationShow.TotalStrike];
        level_Outlet.text = strgStrikeSymbol; 
        if (locationObj.LocationId==0) {
            totalStrike_Outlet.text = [NSString stringWithFormat:@"%i",locationObj.TotalStrike] ;
        }
        else{
           totalStrike_Outlet.text = [NSString stringWithFormat:@"%i",locationShow.TotalStrike] ; 
        }
        
        total_Storm.text = [NSString stringWithFormat:@"%i",locationShow.TotalStromCount];
        liveFeeds_M_outlet.text = [NSString stringWithFormat:@"%i (%i)",locationShow.TotalMale,locationShow.AverageMale]; 
        liveFeeds_F_Outlet.text = [NSString stringWithFormat:@"%i (%i)",locationShow.TotalFemale,locationShow.AverageFemale];
        avgAge_Outlet.text = [NSString stringWithFormat:@"%i Yr",locationShow.AverageAge];
        
        [self giveStrikeSymbolOnBasisOfStrike:locationShow.LargestStrikeCount];
        largestStorm.text  = strgStrikeSymbol;
       
        
        if (locationShow.LargestStrikeCount < 20) {
            largestStormDateTime.text = @"";
        }
        else
        {
            //largestStormDateTime.text = [NSString stringWithFormat:@"%@ %i strike(s)",locationShow.LargestStrikeCreatedDate,locationShow.TotalStrike];
              largestStormDateTime.text = [NSString stringWithFormat:@"%@ %i strike(s)",locationShow.LargestStrikeCreatedDate,locationShow.LargestStrikeCount];
        }

        
            if ([locationShow.Photo isEqualToString:@""]||locationShow.Photo==nil)
            {
                locationImageView.image = [UIImage imageNamed:@"no_image_location.png"];
            }else
            {
               /* NSURL *myURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=100&photoreference=%@&sensor=false&key=AIzaSyAfXbpScWudV9n79teEzazPNkhqGZjjVJA",locationShow.Photo]];
                [locationImageView setImageWithURL:myURL];*/
                //locationImageView.image =[UIImage imageWithData:[UIImage base64DataFromString:locationShow.Photo]];
              
                
              
                
                /*NSString *ImageURL = [[NSString alloc] initWithData:[UIImage base64DataFromString:locationShow.Photo] encoding:NSUTF8StringEncoding];
                NSData *imageData = [[NSData alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]]];
                locationImageView.image = [UIImage imageWithData:imageData];*/
               
                UIImage* loadingImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no_image_location" ofType:@"png"]];
                
                NSString *ImageURL = [[NSString alloc] initWithData:[UIImage base64DataFromString:locationShow.Photo] encoding:NSUTF8StringEncoding];
                
                [locationImageView setImageWithURL:[NSURL URLWithString:ImageURL] placeholderImage:nil success:^(UIImage* img){
                    
                    [locationImageView setImage:img];
                    
                } failure:^(NSError* err){
                    
                    
                    [locationImageView setImage:loadingImage];
                }];
            }
            
            if ([locationShow.LocationAddress isEqualToString:@""])
            {
                phoneNumber_Outlet.text = @"";
                emailAddress_Outlet.text = @"";
            }else
            {
               /* NSURL *myURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=false&key=AIzaSyAfXbpScWudV9n79teEzazPNkhqGZjjVJA",locationShow.LocationAddress]];
                //[ img setImageWithURL:myURL];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL1
                                                                       cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                   timeoutInterval:60];
                [[NSURLConnection alloc] initWithRequest:request delegate:self];*/
                NSData *phoneData=[UIImage base64DataFromString:locationShow.LocationAddress];
                NSString *decodedString = [[NSString alloc] initWithData:phoneData encoding:NSUTF8StringEncoding];
                phoneNumber_Outlet.text = decodedString;
                if ([phoneNumber_Outlet.text length] > 0)
                {
                    //Adjusting the phone number label width
                    //CGSize textSize = [phoneNumber_Outlet.text sizeWithFont:[phoneNumber_Outlet font] forWidth:phoneNumber_Outlet.bounds.size.width lineBreakMode:UILineBreakModeWordWrap];
 
                    // DAJ 20150622 replace depricated sizeWithFont
                    CGRect textRect = [phoneNumber_Outlet.text  boundingRectWithSize:phoneNumber_Outlet.frame.size  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:phoneNumber_Outlet.font} context:nil];
                    phone_outlet.frame=CGRectMake(phone_outlet.frame.origin.x,phone_outlet.frame.origin.y, textRect.size.width, phone_outlet.frame.size.height);
                    phoneNumber_Outlet.frame=CGRectMake(phoneNumber_Outlet.frame.origin.x,phoneNumber_Outlet.frame.origin.y, textRect.size.width, phoneNumber_Outlet.frame.size.height);
                    
                }

            }
       
        
//        self.navigationItem.rightBarButtonItem = nil;
//        
//        UIImage* buttonImage1 = nil;
//        
//        if (!locationShow.IsFavorite) {
//            buttonImage1 = [UIImage imageNamed:@"favorite_icn.png"];
//            hybridCheckBox = NO;
//        }else
//        {
//            buttonImage1 = [UIImage imageNamed:@"favorited_icn.png"];
//            hybridCheckBox = YES;
//            
//        }
//        
//        
//        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
//        [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
//        [rightButton addTarget:self action:@selector(favoriteTarget:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        self.navigationItem.rightBarButtonItem=back_btn;
//        [back_btn release];
        
        UIImage* buttonImage1 = nil;
        
        if (!locationShow.IsFavorite) {
            buttonImage1 = [UIImage imageNamed:@"favorite_icn.png"];
            hybridCheckBox = NO;
        }else
        {
            buttonImage1 = [UIImage imageNamed:@"favorited_icn.png"];
            hybridCheckBox = YES;
            
        }
        
        if (locationShow.LocationId==0) {
           self.navigationItem.rightBarButtonItem=nil;            
            
        }
        else{
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
            rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
            [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
            [rightButton addTarget:self action:@selector(favoriteTarget:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
            self.navigationItem.rightBarButtonItem=back_btn;
            [back_btn release];

        }

    
    
    }
    
    
}

-(void)getFavResponse:(NSDictionary*)response{
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:@"Unfavorited  successfully" tittle:nil];
        return;
    }else
    {
         //[appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
         [appDelegate showAlertMessage:@"Unfavorited  successfully" tittle:nil];
    }
    
    
}

-(void)getUnFavResponse:(NSDictionary*)response{
    
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:@"Favorited successfully" tittle:nil];
        return;
    }else
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

-(void)giveStrikeSymbolOnBasisOfStrike:(int)intStrike
{
    if (intStrike < 20) {
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

 
    /*if (intStrike <= 5)
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
        
    }*/
}


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
        //[localDoct setValue:[NSString stringWithFormat:@"%i",locationObj.LocationId] forKey:@"LocationId"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",locationShow.LocationId] forKey:@"LocationId"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",usersData.UserId] forKey:@"UserId"];
        [localDoct setValue:[NSNumber numberWithBool:FALSE] forKey:@"IsFavorite"];
        [appDelegate startAnimatingIndicatorView];
      
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getFavResponse:);
        [temp postParseInfoWithUrlPath:KUnFavoriteLocation WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];

        
        
        
    }else
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
       // [localDoct setValue:[NSString stringWithFormat:@"%i",locationObj.LocationId] forKey:@"LocationId"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",locationShow.LocationId] forKey:@"LocationId"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",usersData.UserId] forKey:@"UserId"];
        [localDoct setValue:[NSNumber numberWithBool:TRUE] forKey:@"IsFavorite"];
        
        [appDelegate startAnimatingIndicatorView];
      
        
        
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getUnFavResponse:);
        [temp postParseInfoWithUrlPath:KSaveAsFavoriteLocation WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
               
    }

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)dealloc {
    [location_Outlet release];
    [level_Outlet release];
    [totalStrike_Outlet release];
    [total_Storm release];
    [liveFeeds_M_outlet release];
    [liveFeeds_F_Outlet release];
    [avgAge_Outlet release];
    [phoneNumber_Outlet release];
    [emailAddress_Outlet release];
    [largestStorm release];
    [largestStormDateTime release];
    [locationImageView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [location_Outlet release];
    location_Outlet = nil;
    [level_Outlet release];
    level_Outlet = nil;
    [totalStrike_Outlet release];
    totalStrike_Outlet = nil;
    [total_Storm release];
    total_Storm = nil;
    [liveFeeds_M_outlet release];
    liveFeeds_M_outlet = nil;
    [liveFeeds_F_Outlet release];
    liveFeeds_F_Outlet = nil;
    [avgAge_Outlet release];
    avgAge_Outlet = nil;
    [phoneNumber_Outlet release];
    phoneNumber_Outlet = nil;
    [emailAddress_Outlet release];
    emailAddress_Outlet = nil;
    [largestStorm release];
    largestStorm = nil;
    [largestStormDateTime release];
    largestStormDateTime = nil;
    [locationImageView release];
    locationImageView = nil;
    [super viewDidUnload];
}
- (IBAction)chaseITAction:(id)sender {
    
    CLLocation *myLocation = appDelegate.currentlocation;
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    
    
    CLLocationCoordinate2D destination = { [locationObj.Latitude floatValue],[locationObj.longitude floatValue]};
    
    NSMutableString *googleAppleMapsURLString = [[NSMutableString alloc] init];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0 )
    {
        [googleAppleMapsURLString setString:[NSString stringWithFormat:@"http://maps.google.com/?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",locationCoordinate.latitude, locationCoordinate.longitude, destination.latitude, destination.longitude] ];
        
    }else
    {
         //[googleAppleMapsURLString setString:[NSString stringWithFormat:@"http://maps.apple.com/maps?daddr=%1.6f,%1.6f&saddr=%1.6f,%1.6f",locationCoordinate.latitude, locationCoordinate.longitude, destination.latitude, destination.longitude]];
        [googleAppleMapsURLString setString:[NSString stringWithFormat:@"http://maps.apple.com/maps?saddr=%1.6f,%1.6f&daddr=%1.6f,%1.6f",locationCoordinate.latitude, locationCoordinate.longitude, destination.latitude, destination.longitude]];
       
    }
   
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleAppleMapsURLString]];
    
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


#pragma mark NSURLCONNECTIONDELEGATE

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
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
     emailAddress_Outlet.text=@"";
     phoneNumber_Outlet.text = [dataarray valueForKey:@"formatted_phone_number"];
    
    if ([phoneNumber_Outlet.text length]>0)
    {
        //Adjusting the phone number label width
//        CGSize textSize = [phoneNumber_Outlet.text sizeWithFont:[phoneNumber_Outlet font] forWidth:phoneNumber_Outlet.bounds.size.width lineBreakMode:UILineBreakModeWordWrap];

        // DAJ 20150622 replace depricated sizeWithFont
        CGRect textRect = [phoneNumber_Outlet.text  boundingRectWithSize:phoneNumber_Outlet.frame.size  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:phoneNumber_Outlet.font} context:nil];
        phone_outlet.frame=CGRectMake(phone_outlet.frame.origin.x,phone_outlet.frame.origin.y, textRect.size.width, phone_outlet.frame.size.height);
        phoneNumber_Outlet.frame=CGRectMake(phoneNumber_Outlet.frame.origin.x,phoneNumber_Outlet.frame.origin.y, textRect.size.width, phoneNumber_Outlet.frame.size.height);
    
    }
    
    
}
-(IBAction)makeCall:(id)sender
{
    BOOL canCall = [[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",phoneNumber_Outlet.text] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
    if (canCall) {
        if ([phoneNumber_Outlet.text length]>0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"tel:%@",phoneNumber_Outlet.text] stringByReplacingOccurrencesOfString:@" " withString:@""]]];
        }
    }
    else{
         [appDelegate showAlertMessage:@"Phone calling not exist" tittle:nil];
    }
    
    
}







@end
