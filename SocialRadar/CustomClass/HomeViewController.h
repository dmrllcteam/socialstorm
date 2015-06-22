//
//  HomeViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 13/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class Location;
@class CalloutMapAnnotation;

@interface HomeViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>
{
    IBOutlet MKMapView *mapViewHome;
    CLLocation *currentLocation;
    int count;
   // UIImageView *imgView;
    CalloutMapAnnotation*  _calloutAnnotation;
     MKAnnotationView* selectedAnnotationView;
    IBOutlet UIImageView *lighteningImgView;
    IBOutlet UIView *darkHideView;
    NSMutableArray *arrayOfStrorm;
    UIView *loaderView;
    CLLocationManager *locationManager;
    BOOL isFromHomeView;
    MPMoviePlayerController *theMovie;
    int locTotalstrike;
    NSTimer *timer;
 
}
@property(nonatomic, retain)Location* mylocation;
@property(nonatomic, strong)IBOutlet MKMapView *mapViewHome;


- (IBAction)navigationBttnAction:(id)sender;


@end

