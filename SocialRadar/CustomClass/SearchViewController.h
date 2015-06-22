//
//  SearchViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 28/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface SearchViewController : UIViewController<UISearchBarDelegate,MKMapViewDelegate>
{
    IBOutlet UISearchBar *searchBarMap;
    IBOutlet MKMapView *search_MapView;
     CLLocation *currentLocation;
}

- (IBAction)currentLocationButtons:(id)sender;

@end
