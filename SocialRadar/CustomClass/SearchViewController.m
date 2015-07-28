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
 
    
    
}

-(void)callFourSquareLocations:(NSString *)searchText
{
    //Search within the _SEARCHVIEW_SEARCH_RADIUS  from the current location.
    
    NSString *lat=[NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.latitude];
    NSString *longt=[NSString stringWithFormat:@"%f",appDelegate.currentlocation.coordinate.longitude];
    
    //New Foursquare Trending API
   [Foursquare2 venueSearchNearByLatitude:[NSNumber numberWithFloat:[lat floatValue]] longitude:[NSNumber numberWithFloat:[longt floatValue]] query:searchText limit:[NSNumber numberWithInteger:50] intent:intentBrowse radius:@(_SEARCHVIEW_SEARCH_RADIUS) categoryId:nil callback:^(BOOL success, id result)
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
