//
//  NearByLocationViewControlerViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 19/06/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import  "NearByLocationViewControlerViewController.h"
#import  "HallOfFrameViewCell.h"
#import  "JSON.h"
#include "NearByLocation.h"
#import  "ShareStrikeViewController.h"
#import  "Common_IPhone.h"
#import  "Location.h"
#import  "Strike.h"
#import  "AppDelegate.h"
#import "User.h"
#import "UIImage+Base64Image.h"
#import "Foursquare2.h"
#import "FSVenue.h"
#import "FSConverter.h"
#include <stdlib.h>
#import "CLXURLConnection.h"

@interface NearByLocationViewControlerViewController ()

@end

@implementation NearByLocationViewControlerViewController
{
    int counter;
    float latSum;
    float longSum;
    NSString *selected_filter;
    BOOL isRecently_Opened;
}
@synthesize hallOfFarame_Cell, currentLocationsProperty;
@synthesize selected;
@synthesize nearbyVenues;
@synthesize timer;
@synthesize arrayResult;

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
    
    self.navigationItem.hidesBackButton = YES;
    self.title = @"Strike Location";
    NSDate *date = [NSDate date];
    NSTimeInterval today = [date timeIntervalSince1970];
    NSString *intervalString = [NSString stringWithFormat:@"%ld", (long)today];
    NSLog(@"interval stamp=%@",intervalString);
    
    UIImage* buttonImage1 = [UIImage imageNamed:@"back_btn.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
    [leftButton setImage:buttonImage1 forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=back_btn;
    [back_btn release];
    
    mainArray = [[NSMutableArray alloc] init];
    selected_filter=@"";
    isRecently_Opened=NO;
}

-(void)filterTarget:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Nearby",@"Specials",@"Food",@"Nightlife",@"Coffee",@"Sights",@"Arts",@"Trending",@"Recently Opened",@"Bar", nil];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}
#pragma mark
#pragma mark UIActionDelegate Delegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            selected_filter=@"";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        case 1:
        {
            selected_filter=@"specials";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        case 2:
        {
            selected_filter=@"food";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        case 3:{
            selected_filter=@"Nightlife";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        case 4:
        {
            selected_filter=@"coffee";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        case 5:
        {
            selected_filter=@"sights";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        case 6:
        {
            selected_filter=@"arts";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        
        case 7:
        {
            
            selected_filter=@"trending";
            isRecently_Opened=NO;
            [self Averagelocations:nil];
            break;
        }
        case 8:
        {
            selected_filter=@"Recently Opened";
            isRecently_Opened=YES;
            [self Averagelocations:nil];
            break;
        }
        case 9:
        {
            selected_filter = @"Bar";
            isRecently_Opened = NO;
            [self Averagelocations:nil];
            break;
        }
        default:
            break;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate startAnimatingIndicatorView];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    counter=10;
    latSum=0;
    longSum=0;
    timer = [NSTimer scheduledTimerWithTimeInterval:01 target:self selector:@selector(Averagelocations:)  userInfo:nil repeats:NO];
}

-(void)Averagelocations:(NSTimer *)Timer
{
   
   
    
   //Venue/Search
    CLLocation *myLocation = appDelegate.currentlocation;
    CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(myLocation.coordinate.latitude, myLocation.coordinate.longitude);
    
    [Foursquare2 venueSearchNearByLatitude:[NSNumber numberWithFloat:locationCoordinate.latitude] longitude:[NSNumber numberWithFloat:locationCoordinate.longitude]                                                                                                         query:@"" limit:[NSNumber numberWithInt:50] intent:intentBrowse radius:@(NearByLatitude) categoryId:nil callback:^(BOOL success, id result)
    {
        if (success)
        {
            [appDelegate stopAnimatingIndicatorView];
            //  NSLog(@"foursquare result=%@",result);
            NSDictionary *jsonObject = result;
            NSMutableArray *venues = [jsonObject valueForKeyPath:@"response.venues"];
            if ([venues  count]!=0)
            {
                       
                if ([mainArray count])
                {
                    [mainArray removeAllObjects];
                }
                for (int i =0 ; i < [venues count]; i++)
                {
                    NearByLocation *nearByLocation = [[NearByLocation alloc] initWithDict:[venues objectAtIndex:i]];
                    [mainArray addObject:nearByLocation];
                    [nearByLocation release];
                }
                        
                    _RELEASE(arrayResult)
                    arrayResult=[[NSMutableArray alloc] initWithArray:venues];
                    [nearByLocation_TableView reloadData];
                }
                        //[arrayResult release];
            }
            else
            {
                [appDelegate stopAnimatingIndicatorView];
                    
                NSLog(@"fetch location list failed-foursquare");
            }
    }];
}


-(void)backTarget:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
       [nearByLocation_TableView release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [nearByLocation_TableView release];
    nearByLocation_TableView = nil;
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (void)loadURL:(NSString *)ur
{
    NSURL *myURL = [NSURL URLWithString:ur];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:myURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

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
    
    [appDelegate stopAnimatingIndicatorView];
    [responseData release];
    [connection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    [appDelegate stopAnimatingIndicatorView];
    NSString *txt = [[[NSString alloc] initWithData:responseData encoding: NSASCIIStringEncoding] autorelease];
    NSString *dicstr=txt ;
    NSDictionary *jsonObject = [dicstr JSONValue];
    
    if ([[jsonObject valueForKey:@"status"]isEqualToString:@"OVER_QUERY_LIMIT"])
    {
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Google Map response exceeded the daily limit." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        errorAlert.tag=1001;
        [errorAlert show];
        _RELEASE(errorAlert);
    }
    else if ([[jsonObject valueForKey:@"status"]isEqualToString:@"ZERO_RESULTS"])
    {
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        _RELEASE(errorAlert);
        
    }
    else
    {
        NSMutableArray *arrayResult2 = [jsonObject valueForKey:@"results"];
        
        if (mainArray)
        {
            [mainArray removeAllObjects];
        }
        
        for (int i =0 ; i < [arrayResult2 count]; i++)
        {
            NearByLocation *nearByLocation = [[NearByLocation alloc] initWithDict:[arrayResult objectAtIndex:i]];
            [mainArray addObject:nearByLocation];
            [nearByLocation release];
        }
        
        [nearByLocation_TableView reloadData];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [mainArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableIdentifierOne";
    NearByLocation *nearByLocationsCellRow = [mainArray objectAtIndex:indexPath.row];
    
    hallOfFarame_Cell = (HallOfFrameViewCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (hallOfFarame_Cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HallOfFrameViewCell" owner:self options:nil];
        // [registerTableViewCell setNeedsDisplay];
        hallOfFarame_Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    //NSInteger rows = indexPath.row + 1;
    
    hallOfFarame_Cell.label_cell.text = [NSString stringWithFormat:@"%@",nearByLocationsCellRow.locationName];
    hallOfFarame_Cell.stornImage_cell.hidden = YES;
    hallOfFarame_Cell.bolt_imageView.image = [UIImage imageNamed:@"bolt_icn.png"];
    
    //hallOfFarame_Cell = [[HallOfFrameViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    return hallOfFarame_Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NearByLocation *nearByLocationsDidSelect = [mainArray objectAtIndex:indexPath.row];
    
    
    Location *location = [[Location alloc] init];
    location.LocationName = nearByLocationsDidSelect.locationName ; // put the location name
    location.longitude = nearByLocationsDidSelect.logitude; // put the longitude
    location.Latitude  = nearByLocationsDidSelect.latitude; // put the latitude
    location.Photo = nearByLocationsDidSelect.photos_Refrence; // with the help of this refrence we get the photo
    location.LocationAddress = nearByLocationsDidSelect.contact_Refrence;// with the help of the refrence we get the contact
    
    //    Strike *strike = [Strike new];
    //    strike.LocationDetails = location;
    //    strike.UserDetails = appDelegate.appdelegateUser;
    
    
    self.nearbyVenues= [[NSMutableArray alloc] init];
    
    [appDelegate startAnimatingIndicatorView];
    
    NSLog(@"Nearbylocaton=%@",[arrayResult objectAtIndex:indexPath.row]);
    NSLog(@"fscount%@",[[[[arrayResult objectAtIndex:indexPath.row]valueForKey:@"venue"] valueForKey:@"hereNow"] valueForKey:@"count"]);
     NSLog(@"venueid%@",[[[arrayResult objectAtIndex:indexPath.row]valueForKey:@"venue"] valueForKey:@"id"] );
    
    
    if (arrayResult.count>0) {
        NSString *checkinsCount=[[[arrayResult objectAtIndex:indexPath.row]valueForKey:@"hereNow"] valueForKey:@"count"];
         NSString *venueid=[[arrayResult objectAtIndex:indexPath.row] valueForKey:@"id"];
       
        // NSString *checkinsCount= [NSString stringWithFormat:@"%d",[self randomNumberBetween:21 maxNumber:31]];
       // NSString *venueid=[[arrayResult objectAtIndex:indexPath.row] valueForKey:@"id"];
        
        //change to venue/explore
       // NSString *checkinsCount=[[[[arrayResult objectAtIndex:indexPath.row]valueForKey:@"venue"] valueForKey:@"hereNow"] valueForKey:@"count"];
       // NSString *venueid=[[[arrayResult objectAtIndex:indexPath.row] valueForKey:@"venue"]valueForKey:@"id"];
        //
        NSLog(@"venueid=%@",venueid);
        NSLog(@" checkinsCount - %@",checkinsCount);
        // FSConverter *converter = [[FSConverter alloc]init];
        // self.nearbyVenues = [converter convertToObjects:venues];
       // NSLog(@"%@",self.nearbyVenues);
        NSLog(@" --------- print ---------- %d",[nearbyVenues count]);
        
        NSMutableDictionary  *locationDetails=[[NSMutableDictionary alloc] init];
        [locationDetails setValue:nearByLocationsDidSelect.locationName forKey:@"LocationName"];
        [locationDetails setValue:nearByLocationsDidSelect.logitude forKey:@"longitude"];
        [locationDetails setValue:nearByLocationsDidSelect.latitude forKey:@"Latitude"];
        [locationDetails setValue:nearByLocationsDidSelect.photos_Refrence forKey:@"Photo"];
        [locationDetails setValue:nearByLocationsDidSelect.contact_Refrence forKey:@"LocationAddress"];
        [locationDetails setValue:checkinsCount forKey:@"FSCheckinCount"];
        [locationDetails setValue:venueid forKey:@"FSLocationId"];
        
        User *usersData = appDelegate.appdelegateUser;
        NSMutableDictionary  *userDeatails=[[NSMutableDictionary alloc] init];
        [userDeatails setValue:usersData.Name forKey:@"Name"];
        [userDeatails setValue:[NSString stringWithFormat:@"%i",usersData.Age] forKey:@"Age"];
        [userDeatails setValue:usersData.EmailAddress forKey:@"EmailAddress"];
        [userDeatails setValue:usersData.UserName forKey:@"UserName"];
        [userDeatails setValue:usersData.Password forKey:@"Password"];
        [userDeatails setValue:usersData.RelationshipStatus forKey:@"RelationshipStatus"];
        [userDeatails setValue:usersData.Gender forKey:@"Gender"];
        [userDeatails setValue:usersData.PhoneNo forKey:@"PhoneNo"];
        [userDeatails setValue:[NSString stringWithFormat:@"%i",usersData.UserId] forKey:@"UserId"];
        
        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        [localDoct setValue:locationDetails forKey:@"LocationDetails"];
        [localDoct setValue:userDeatails forKey:@"UserDetails"];
        
        //FSCheckinCount
        
        [appDelegate startAnimatingIndicatorView];
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getupdateResponse:);
        [temp postParseInfoWithUrlPath:KSaveStrikeDetails WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];

    }
    else{
        // no found count 0po
        NSMutableDictionary  *locationDetails=[[NSMutableDictionary alloc] init];
        [locationDetails setValue:nearByLocationsDidSelect.locationName forKey:@"LocationName"];
        [locationDetails setValue:nearByLocationsDidSelect.logitude forKey:@"longitude"];
        [locationDetails setValue:nearByLocationsDidSelect.latitude forKey:@"Latitude"];
        [locationDetails setValue:nearByLocationsDidSelect.photos_Refrence forKey:@"Photo"];
        [locationDetails setValue:nearByLocationsDidSelect.contact_Refrence forKey:@"LocationAddress"];
        [locationDetails setValue:@"0" forKey:@"FSCheckinCount"];
        [locationDetails setValue:@"0" forKey:@"FSLocationId"];
        
        User *usersData = appDelegate.appdelegateUser;
        NSMutableDictionary  *userDeatails=[[NSMutableDictionary alloc] init];
        [userDeatails setValue:usersData.Name forKey:@"Name"];
        [userDeatails setValue:[NSString stringWithFormat:@"%i",usersData.Age] forKey:@"Age"];
        [userDeatails setValue:usersData.EmailAddress forKey:@"EmailAddress"];
        [userDeatails setValue:usersData.UserName forKey:@"UserName"];
        [userDeatails setValue:usersData.Password forKey:@"Password"];
        [userDeatails setValue:usersData.RelationshipStatus forKey:@"RelationshipStatus"];
        [userDeatails setValue:usersData.Gender forKey:@"Gender"];
        [userDeatails setValue:usersData.PhoneNo forKey:@"PhoneNo"];
        [userDeatails setValue:[NSString stringWithFormat:@"%i",usersData.UserId] forKey:@"UserId"];
        
        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        [localDoct setValue:locationDetails forKey:@"LocationDetails"];
        [localDoct setValue:userDeatails forKey:@"UserDetails"];
        
        //FSCheckinCount
        
        [appDelegate startAnimatingIndicatorView];
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getupdateResponse:);
        [temp postParseInfoWithUrlPath:KSaveStrikeDetails WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
        
        
    }
  
}



#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response{
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        return;
    }else
    {
    //[appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        
        //Author Sanjay: Show the yellow trigger only when the strike has been made
        [appDelegate setbuttonImage:true];
        Location *location = [[Location alloc] initWithNode:[[response valueForKey:@"LocationDetails"] mutableCopy]];
        
        ShareStrikeViewController *shareStrike = [[ShareStrikeViewController alloc] initWithNibName:@"ShareStrikeViewController" bundle:nil];
        shareStrike.location = [location retain];
       [self.navigationController pushViewController:shareStrike animated:YES];
        [shareStrike release];
    }
    
}
- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random_uniform(max - min + 1);
}
#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
