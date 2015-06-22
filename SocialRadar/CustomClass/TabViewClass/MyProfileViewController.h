//
//  MyProfileViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 13/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingViewCell;

@interface MyProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UILabel *userName_lbl;
    IBOutlet UILabel *level_lbl;
    IBOutlet UILabel *totalStrikes_lbl;
    IBOutlet UILabel *sex_lbl;
    IBOutlet UILabel *relationShipStatus_lbl;
    IBOutlet UILabel *age_lbl;
    IBOutlet UILabel *phoneNumber_lbl;
    IBOutlet UILabel *emailAddress_lbl;
    IBOutlet UIImageView *userImage_imageView;
    IBOutlet UITableView *favorites_tableView;
    IBOutlet UIScrollView *myProfile_ScrollView;
    IBOutlet SettingViewCell *cell;
    IBOutlet UILabel *larestStorm_lbl;
    IBOutlet UIView* profileTableView;
    IBOutlet UILabel *totalStorm_lbl;
    
    NSMutableArray *arrayOfLocationList;
    
    
}


@property(nonatomic,retain) IBOutlet UITableView *favorites_tableView;
@property(nonatomic,retain) IBOutlet UIView* profileTableView;;

@end
