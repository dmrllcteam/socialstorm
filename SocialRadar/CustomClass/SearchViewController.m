//
//  SearchViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 28/05/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "SBJSON.h"
#import "NearByLocation.h"
#import "SearchResultView.h"
#import "Common_IPhone.h"
#import "Foursquare2.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
     self.navigationItem.hidesBackButton = YES;
     [search_MapView setShowsUserLocation:YES];
    
     
    
}

-(void) viewWillAppear:(BOOL)animated
{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    if ([[userDefault valueForKey:checkMapStyle] boolValue]){
   
        [search_MapView setMapType:MKMapTypeHybrid];
    }else{
       
        [search_MapView setMapType:MKMapTypeStandard];
    }
    [self.navigationController.navigationBar addSubview:searchBarMap];
    [searchBarMap becomeFirstResponder];
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    [searchBarMap removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    [searchBarMap release];
    [search_MapView release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [searchBarMap release];
    searchBarMap = nil;
    [search_MapView release];
    search_MapView = nil;
    [super viewDidUnload];
}

#pragma mark UISearchBar Delegate

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [appDelegate startAnimatingIndicatorView];
    [self callFourSquareLocations:searchBar.text];
    [searchBarMap resignFirstResponder];
 
    
  /* 
   //Commented in order to use foursquare api for showing the searched location list//
   NSString *lat=[NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
    NSString *longt=[NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
    
    NSString *searchTwo = [searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //comment out the below 2line
    //NSString *str=[@"%" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //searchTwo=[NSString stringWithFormat:@"%@%@",str,searchTwo];
    //[NSString stringWithFormat:@"'%@'",searchTwo]
    
    NSURL *myURL1 = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?location=%@,%@&radius=35000&query=%@&sensor=true&key=AIzaSyAfXbpScWudV9n79teEzazPNkhqGZjjVJA",lat,longt,[NSString stringWithFormat:@"'%@'",searchTwo] ]];
    //[ img setImageWithURL:myURL];
    
    NSURLRequest* urlRequest = [NSURLRequest requestWithURL:myURL1];
    NSData* data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:nil error:nil];
    NSString* strTemp = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    SBJSON* json = [[SBJSON alloc] init];
    NSDictionary* dict = [NSDictionary dictionaryWithDictionary:[json objectWithString:strTemp]];

    if ([[dict valueForKey:@"status"]isEqualToString:@"OVER_QUERY_LIMIT"]) {
        
        [searchBarMap resignFirstResponder];
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Google Map response exceeded the daily limit." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         errorAlert.tag=1001;
        [errorAlert show];
        _RELEASE(errorAlert);
    }
    else if ([[dict valueForKey:@"status"]isEqualToString:@"ZERO_RESULTS"]){
        UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errorAlert show];
        _RELEASE(errorAlert);

    }
    else{
        NSMutableArray *arrayResult = [dict valueForKey:@"results"];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchBar.text]; // if you need case sensitive search avoid '[c]' in the predicate
        for (int i =0 ; i < [arrayResult count]; i++)
        {
            NSDictionary *dict=[arrayResult objectAtIndex:i];
            //Matching the search location
            if ([predicate evaluateWithObject:[dict valueForKey:@"name"]]) {
                NearByLocation *nearByLocation = [[NearByLocation alloc] initWithDict:[arrayResult objectAtIndex:i]];
                [array addObject:nearByLocation];
                [nearByLocation release];
            }
            
            
        }
        
        SearchResultView *search = [[SearchResultView alloc] initWithNibName:@"SearchResultView" bundle:nil];
        search.arrayOfTextSearch = [array retain];
        [self.navigationController pushViewController:search animated:YES];
        [search release];
        
        [array release];
        array = nil;
    }*/
       
    
}

-(void)callFourSquareLocations:(NSString *)searchText
{
    //Search within the 21 miles radius from the current location.
    
    NSString *lat=[NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
    NSString *longt=[NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
    
    /*//Showing location list using Foursquare API
    [Foursquare2 searchVenuesNearByLatitude:[NSNumber numberWithFloat:[lat floatValue]] longitude:[NSNumber numberWithFloat:[longt floatValue]]
                                 accuracyLL:nil
                                   altitude:nil
                                accuracyAlt:nil
                                      query:searchText
                                      limit:[NSNumber numberWithInteger:10]
                                     intent:intentCheckin
                                     radius:@(35000)
                                 categoryId:nil
                                   callback:^(BOOL success, id result){
                                       if (success)
                                       {
                                           NSDictionary *jsonObject = result;
                                           NSMutableArray *arrayResult = [jsonObject valueForKeyPath:@"response.venues"];
                                           NSMutableArray *mainArray = [[NSMutableArray alloc] init];
                                           NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText]; // if you need case sensitive search avoid '[c]' in the predicate
                                           for (int i =0 ; i < [arrayResult count]; i++)
                                           {
                                               if ([predicate evaluateWithObject:[[arrayResult objectAtIndex:i] valueForKey:@"name"]])
                                               {
                                                   NearByLocation *nearByLocation = [[NearByLocation alloc] initWithDict:[arrayResult objectAtIndex:i]];
                                                   [mainArray addObject:nearByLocation];
                                                   [nearByLocation release];
                                                   
                                               }
                                           }
                                           if (mainArray.count) {
                                               SearchResultView *search = [[SearchResultView alloc] initWithNibName:@"SearchResultView" bundle:nil];
                                               search.arrayOfTextSearch = [mainArray retain];
                                               [self.navigationController pushViewController:search animated:YES];
                                               [search release];
                                               
                                               [mainArray release];
                                               mainArray = nil;
                                           }
                                           else{
                                               UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                               errorAlert.tag=1002;
                                               [errorAlert show];
                                               _RELEASE(errorAlert);
                                           
                                           }
         
                                        }
                                       else{
                                           
                                           UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                           errorAlert.tag=1002;
                                           [errorAlert show];
                                           _RELEASE(errorAlert);
                                       }
                                   }];
    //end of showling location list using Foursquare API*/
    
    //New Foursquare Trending API
   [Foursquare2 venueSearchNearByLatitude:[NSNumber numberWithFloat:[lat floatValue]] longitude:[NSNumber numberWithFloat:[longt floatValue]] query:searchText limit:[NSNumber numberWithInteger:50] intent:intentBrowse radius:@(19312.08) categoryId:nil callback:^(BOOL success, id result)
    {
        if (success)
        {
            NSDictionary *jsonObject = result;
            NSMutableArray *arrayResult = [jsonObject valueForKeyPath:@"response.venues"];
            NSMutableArray *mainArray = [[NSMutableArray alloc] init];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText]; // if you need case sensitive search avoid '[c]' in the predicate
            for (int i =0 ; i < [arrayResult count]; i++)
            {
                if ([predicate evaluateWithObject:[[arrayResult objectAtIndex:i] valueForKey:@"name"]])
                {
                    NearByLocation *nearByLocation = [[NearByLocation alloc] initWithDict:[arrayResult objectAtIndex:i]];
                    [mainArray addObject:nearByLocation];
                    [nearByLocation release];
                    
                }
            }
            if (mainArray.count)
            {
                SearchResultView *search = [[SearchResultView alloc] initWithNibName:@"SearchResultView" bundle:nil];
                search.arrayOfTextSearch = [mainArray retain];
                [self.navigationController pushViewController:search animated:YES];
                [search release];
                
                [mainArray release];
                mainArray = nil;
            }
            else{
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                errorAlert.tag=1002;
                [errorAlert show];
                _RELEASE(errorAlert);
                
            }
            
        }
        else{
            
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            errorAlert.tag=1002;
            [errorAlert show];
            _RELEASE(errorAlert);
        }

    }];
    //End of  Foursquare Trending API
    
    //Venue/Explore
   
    /*[Foursquare2 venueExploreRecommendedNearByLatitude:[NSNumber numberWithFloat:[lat floatValue]] longitude:[NSNumber numberWithFloat:[longt floatValue]] near:nil accuracyLL:[NSNumber numberWithFloat:10000.0] altitude:[NSNumber numberWithInt:0] accuracyAlt:[NSNumber numberWithFloat:10000.0] query:nil limit:[NSNumber numberWithInt:50] offset:nil radius:[NSNumber numberWithFloat:19312.08] section:nil novelty:nil sortByDistance:NO openNow:NO venuePhotos:NO price:nil callback:^(BOOL success, id result){
            
        NSDictionary *jsonObject = result;
        NSMutableArray *venues2 = [jsonObject valueForKeyPath:@"response.groups.items"];
        NSMutableArray *venues=[venues2 objectAtIndex:0];
        if (success) {
            NSMutableArray *arrayResult = [venues2 objectAtIndex:0];
            NSMutableArray *mainArray = [[NSMutableArray alloc] init];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText]; // if you need case sensitive search avoid '[c]' in the predicate
            for (int i =0 ; i < [arrayResult count]; i++)
            {
                if ([predicate evaluateWithObject:[[[arrayResult objectAtIndex:i] valueForKey:@"venue"] valueForKey:@"name"]])
                {
                    NSMutableDictionary *catDict=[[[[venues objectAtIndex:i] objectForKey:@"venue"] objectForKey:@"categories"] objectAtIndex:0];
                    NSString *prefix= [[catDict objectForKey:@"icon"] valueForKey:@"prefix"];
                    if ([prefix rangeOfString:@"outdoors"].location == NSNotFound) {
                        NearByLocation *nearByLocation = [[NearByLocation alloc] initWithDict:[[venues objectAtIndex:i] objectForKey:@"venue"]];
                        [mainArray addObject:nearByLocation];
                        [nearByLocation release];
                    }
                    
                  
                    
                }
            }
            if (mainArray.count) {
                SearchResultView *search = [[SearchResultView alloc] initWithNibName:@"SearchResultView" bundle:nil];
                search.arrayOfTextSearch = [mainArray retain];
                [self.navigationController pushViewController:search animated:YES];
                [search release];
                
                [mainArray release];
                mainArray = nil;
            }
            else{
                UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                errorAlert.tag=1002;
                [errorAlert show];
                _RELEASE(errorAlert);
                
            }

        
        }
        else{
            UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"No result found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            errorAlert.tag=1002;
            [errorAlert show];
            _RELEASE(errorAlert);
        }
       
    }];*/

    
    
    
    
    
    [self performSelector:@selector(stopAnimatingIndicatorView) withObject:nil afterDelay:4];
}
-(void)stopAnimatingIndicatorView
{
    [appDelegate stopAnimatingIndicatorView];
}

-(void) searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)currentLocationButtons:(id)sender {
    
    [searchBarMap resignFirstResponder];
    currentLocation = search_MapView.userLocation.location;
    double miles = 20.0;
    double scalingFactor = ABS( (cos(2 * M_PI * currentLocation.coordinate.latitude / 360.0) ));
    
    MKCoordinateSpan span;
    
    span.latitudeDelta = miles/69.0;
    span.longitudeDelta = miles/(scalingFactor * 69.0);
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = currentLocation.coordinate;
    
    [search_MapView setRegion:region animated:YES];

}
#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1001) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    if (alertView.tag==1002) {
        [appDelegate stopAnimatingIndicatorView];
    }
}

@end
