//
//  NearByLocationViewControlerViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 19/06/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class FSVenue;
@class HallOfFrameViewCell;
@interface NearByLocationViewControlerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UITableView *nearByLocation_TableView;
    NSMutableData *responseData;
    NSMutableArray *mainArray;
   
    
}
@property (nonatomic , retain) HallOfFrameViewCell *hallOfFarame_Cell;
@property (nonatomic, retain) CLLocation *currentLocationsProperty;

@property (strong,nonatomic)NSArray* nearbyVenues;
@property (strong,nonatomic) NSMutableArray *arrayResult;;
@property (nonatomic ,retain) FSVenue *selected;
@property (nonatomic,retain) NSTimer *timer;
-(void)Averagelocations:(NSTimer *)Timer;
@end
