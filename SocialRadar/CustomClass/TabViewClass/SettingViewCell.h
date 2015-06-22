//
//  SettingViewCell.h
//  SocialRadar
//
//  Created by Mohit Singh on 04/06/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewCell : UITableViewCell
{
    IBOutlet UILabel *setting_lbl;
    IBOutlet UIImageView *imageView;
    
    
}
@property ( nonatomic, retain) IBOutlet UILabel *setting_lbl;
@property ( nonatomic, retain) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIButton *fav_btnOutlet;

@end
