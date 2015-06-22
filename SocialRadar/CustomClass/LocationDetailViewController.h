//
//  LocationDetailViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 02/06/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Location;
@interface LocationDetailViewController : UIViewController
{
     BOOL hybridCheckBox;
    IBOutlet UILabel *location_Outlet;
    IBOutlet UILabel *level_Outlet;
    IBOutlet UILabel *totalStrike_Outlet;
    IBOutlet UILabel *total_Storm;
    IBOutlet UILabel *liveFeeds_M_outlet;
    IBOutlet UILabel *liveFeeds_F_Outlet;
    IBOutlet UILabel *avgAge_Outlet;
    IBOutlet UILabel *phoneNumber_Outlet;
    IBOutlet UILabel *emailAddress_Outlet;
    IBOutlet UILabel *largestStorm;
    IBOutlet UILabel *largestStormDateTime;
    IBOutlet UIImageView *locationImageView;
    IBOutlet UIButton *phone_outlet;
    IBOutlet UIView *contactOverly_outlet;
    IBOutlet UIScrollView *scrollView_outlet;
    NSMutableString *strgStrikeSymbol;
    BOOL isFromHallOfFrame;
    NSMutableData *responseData;
    NSMutableDictionary *dataarray;
    Location *locationShow;
    
}
@property BOOL hybridCheckBox;
@property (nonatomic,retain) Location *locationObj;
@property (nonatomic, assign) BOOL isFromHallOfFrame;


- (IBAction)chaseITAction:(id)sender;
-(IBAction)makeCall:(id)sender;

@end
