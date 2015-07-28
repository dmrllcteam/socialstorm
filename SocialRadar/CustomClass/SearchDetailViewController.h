//
//  SearchDetailViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 02/07/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"

@class NearByLocation;
@interface SearchDetailViewController : UIViewController
{
    
    IBOutlet UILabel *searchLocationName_lbl;
    IBOutlet UILabel *search_lbl;
    IBOutlet UILabel *searchTotalStrike_lbl;
    IBOutlet UILabel *searchTotalStorm_lbl;
    IBOutlet UILabel *searchLargestStorm_lbl;
    IBOutlet UILabel *searchDateAndTimeLargestStorm_lbl;
    IBOutlet UILabel *liveFeeds_Male_lbl;
    IBOutlet UILabel *liveFeeds_Female_lbl;
    IBOutlet UILabel *searchAvgAge_lbl;
    IBOutlet UILabel *searchLocationPhone_lbl;
    IBOutlet UILabel *searchEmailAddress_lbl;
    IBOutlet UIImageView *searchLocationImageView;
    IBOutlet UIButton *phone_outlet;
     NSMutableData *responseData;
     NSMutableDictionary *dataarray;
    
}
@property (nonatomic,retain) NearByLocation *locationObj;
@property(nonatomic, retain)Location* location;
@property (nonatomic) BOOL boolGoogle_Local;
@property BOOL hybridCheckBox;

- (IBAction)searchChaseitAction:(id)sender;
-(IBAction)makeCall:(id)sender;
-(void)favoriteTarget:(id)sender;

@end
