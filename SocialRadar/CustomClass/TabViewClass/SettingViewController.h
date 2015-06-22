//
//  SettingViewController.h
//  SocialRadar
//
//  Created by Mohit Singh on 13/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingViewCell;

@interface SettingViewController : UIViewController
{
    IBOutlet UIView *datePicker_View;
    IBOutlet SettingViewCell *setting_TableViewCell;
    IBOutlet UIDatePicker *datePicker_Outlet;
    IBOutlet UIPickerView *dataPickers;
    IBOutlet UIView *datasPicker;
    IBOutlet UILabel *hidden_lbl;
    
    NSMutableString *stringDates;
    NSMutableString *stringLocation;
    IBOutlet UIImageView *hybridImageViews;
    
    
    NSMutableArray *arrayOfMyFavData;
    
    BOOL hybridCheckBox;
    
    NSMutableArray* locationArray;
    
    NSMutableString* locationId;
    NSMutableString* dateSelectedPicker,*dateSelectedforhiddenlbl;
    bool IsPickertViewPresent;
    UIBarButtonItem *leftBarButton;
   IBOutlet UISwitch *mainSwitch;
    
}

@property (nonatomic,readwrite)BOOL hybridCheckBox;

- (IBAction)datePickerAction:(id)sender;
- (IBAction)autoStrikeAction:(id)sender;
- (IBAction)datasPickersDone:(id)sender;
- (IBAction)hybridButtonAction:(id)sender;
- (IBAction)about:(id)sender;



@end
