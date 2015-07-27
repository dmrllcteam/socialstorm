//
//  SettingViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 13/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "SettingViewController.h"
#import "Common_IPhone.h"
#import "AppDelegate.h"
#import "User.h"
#import "Location.h"
#import "AboutViewController.h"
#import "CLXURLConnection.h"

@interface SettingViewController ()



@end



@implementation SettingViewController
@synthesize hybridCheckBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{

    //GetLocationDetails
    if (locationArray) {
        [locationArray release];
        locationArray = nil;
    }
    
     locationArray = [[NSMutableArray alloc] init];
    
    User *userData = appDelegate.appdelegateUser;
    
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
    
    
   
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponseMyFav:);
    [temp getParseInfoWithUrlPath:KGetFaveoriteLocation WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [hybridImageViews setImage:[UIImage imageNamed:@"check.png"]];
    
    locationId = [[NSMutableString alloc] init];
    dateSelectedPicker = [[NSMutableString alloc] init];
    dateSelectedforhiddenlbl = [[NSMutableString alloc]init];
    stringDates = [[NSMutableString alloc] init];
    stringLocation = [[NSMutableString alloc] init];
   
    
    self.navigationController.navigationBarHidden = NO;
    
    
    self.navigationItem.title = @"Settings";
    
     User *userData = appDelegate.appdelegateUser;
    
    if (![userData.AutoStrikeInfoDetail isKindOfClass:[NSNull class]]) {
        hidden_lbl.text = userData.AutoStrikeInfoDetail;
    }
    
    
    if (hidden_lbl.text.length>1) {
        [mainSwitch setOn:YES];
    }
    
    
    
//   UINavigationBar *navBar = self.navigationController.navigationBar;
//    [navBar setBackgroundImage:navigationImg forBarMetrics:UIBarMetricsDefault];
    
    
//    UIImage* buttonImage1 = [UIImage imageNamed:@"saveSetting.png"];
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
//    [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(saveTarget:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationItem.rightBarButtonItem=back_btn;
//    [back_btn release];
    
    datePicker_Outlet.date = [NSDate date];
    datePicker_Outlet.minimumDate = [NSDate date];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    [df setDateFormat:@"MM/dd/yyyy HH:mm"];
     NSString *strdatesss =  [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker_Outlet.date]];
    [stringDates setString:[NSString stringWithFormat:@"%@",strdatesss]];
    [datePicker_Outlet addTarget:self action:@selector(labelChange:) forControlEvents:UIControlEventValueChanged];

    
    UIButton *leftNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBarButton.frame = CGRectMake(0, 0,RadarImg.size.width, RadarImg.size.height);
    [leftNavBarButton setImage:RadarImg forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(radarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
     leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    [leftBarButton release];
    
}


-(void)radarButtonClick:(id)Sender
{
    [appDelegate.tabBarController setSelectedIndex:1];
    [[[appDelegate.tabBarController viewControllers]objectAtIndex:1] popToRootViewControllerAnimated:NO];
}
    
-(void)saveTarget:(id)Sender
{
    
}


-(void)labelChange:(id)sender
{
 
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    //EEE MMM dd HH:mm:ss
    [df setDateFormat:@"MM/dd/yyyy hh:mm a"];
    //[df setDateFormat:@"EEE, dd MMM YYYY HH:mm:ss VVVV"];
    NSString *strdatesss =  [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker_Outlet.date]];
    // [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker_Outlet.date]];
    [stringDates setString:[NSString stringWithFormat:@"%@",strdatesss]];
    //hidden_lbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker_Outlet.date]];
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@" Setting  memmory receave memory");
    
}

- (void)dealloc {
    
    [locationId release];
    [dateSelectedPicker release];
    [dateSelectedforhiddenlbl release];
    [datePicker_View release];
    [locationArray release];
    [setting_TableViewCell release];
    [datePicker_Outlet release];
    [dataPickers release];
    [datasPicker release];
    [hidden_lbl release];
    [hybridImageViews release];
    [super dealloc];
}
- (void)viewDidUnload {
    [datePicker_View release];
    datePicker_View = nil;
    [setting_TableViewCell release];
    setting_TableViewCell = nil;
    [datePicker_Outlet release];
    datePicker_Outlet = nil;
    [dataPickers release];
    dataPickers = nil;
    [datasPicker release];
    datasPicker = nil;
    [hidden_lbl release];
    hidden_lbl = nil;
    [hybridImageViews release];
    hybridImageViews = nil;
    [super viewDidUnload];
}


- (IBAction)datePickerAction:(id)sender {
    

    if(datePicker_View)
     [datePicker_View removeFromSuperview];
    
     datasPicker.frame = CGRectMake(0, 260, SCREEN_WIDTH, 600); // RAR changes second picker for auto strike alarm
     NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
     NSDateFormatter* dateFormater1 = [[NSDateFormatter alloc] init];
    
    //Used for webservice
    [dateFormater setDateFormat:@"MM-dd-YYYY HH:mm:ss a"];
    [dateSelectedPicker setString:[dateFormater stringFromDate:datePicker_Outlet.date]];
    
    //Used for Local
    [dateFormater1 setDateFormat:@"EEEE, hh:mm a"];
    [dateSelectedforhiddenlbl  setString:[dateFormater1 stringFromDate:datePicker_Outlet.date]];

    
    [dateFormater release];
    [dateFormater1 release];
    [appDelegate hidetabView];
   [appDelegate.tabBarController.view addSubview:datasPicker];
    
}

- (IBAction)autoStrikeAction:(id)sender
{
    
    if ([arrayOfMyFavData count] == 0)
    {
        [appDelegate showAlertMessage:@"First you add in favorite location" tittle:nil];
        UISwitch *switchw = (UISwitch *)sender;
        [switchw setOn:NO];
        return;
    }
    
    UISwitch *switchIS = (UISwitch *)sender;
    
    if (switchIS.on)
    {
        [appDelegate hidetabView];
        // Open the date picker
       // datePicker_View.hidden = NO;
//        if (IS_IPHONE_5)
//        {
        datePicker_View.frame = CGRectMake(0, 260, SCREEN_WIDTH, 620);
//        }else
//        {
            datePicker_View.frame = CGRectMake(0, 260, SCREEN_WIDTH, 620); // RAR changes first picker for auto strike alarm
//        }
        
        datePicker_Outlet.date = [NSDate date];
        datePicker_Outlet.minimumDate = [NSDate date];
        
        [self.parentViewController.tabBarController.view addSubview:datePicker_View];
        
        leftBarButton.enabled=false;
        
    }else
    {
//        datePicker_View.hidden = YES;
         [datePicker_View removeFromSuperview];
         [datasPicker removeFromSuperview];
        [appDelegate showtabView];
          hidden_lbl.text = @"";
        
        
        //To get current timezone
        NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
        localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
        localTimeZoneFormatter.dateFormat = @"Z";
        NSString * localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
        NSMutableString *modifiedOffset = [localTimeZoneOffset mutableCopy];
        [modifiedOffset insertString:@"." atIndex:3];
        
        
        User *userData = appDelegate.appdelegateUser;
        NSMutableDictionary  *localDict=[[NSMutableDictionary alloc] init];
        [localDict setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
        //[localDict setValue:locationId forKey:@"LocationId"];
        [localDict setValue:[NSNumber numberWithBool:false] forKey:@"IsAutoStrikeOn"];
       // [localDict setValue:dateSelectedPicker forKey:@"AutoStrikeAlarmDate"];
       // [localDict setValue:modifiedOffset forKey:@"TimezoneDiff"];
        
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getupdateResponse:);
        [temp postParseInfoWithUrlPath:KConfigureAutoStrikeAlarm WithSelector:selector callerClass:self parameterDic:localDict showloader:NO];

        leftBarButton.enabled=true;
        
    }
}

- (IBAction)datasPickersDone:(id)sender
{
//    NSDateFormatter* dateFormater = [[NSDateFormatter alloc] init];
//    // [dateFormater setDateFormat:@"dd-MM-yyyy HH:mm a"];
//    
//    [dateFormater setDateFormat:@"EEE, dd MMM YYYY HH:mm:ss VVVV"];
//    NSMutableString *dateStr= [[NSString stringWithFormat:@"%@",datePicker_Outlet.date] mutableCopy];
//    hidden_lbl.text = [NSString stringWithFormat:@"%@, %@",dateStr,stringLocation];

    // by Ankur
    int  row = [dataPickers selectedRowInComponent:0];
    
    Location* loc = (Location*)[arrayOfMyFavData objectAtIndex:row];
    
    [stringLocation setString:[NSString stringWithFormat:@"%@",loc.LocationName]];
    [locationId setString:[NSString stringWithFormat:@"%d",loc.LocationId]];
    
    //By Ankur
    
     hidden_lbl.text = [NSString stringWithFormat:@"%@, %@",dateSelectedforhiddenlbl,stringLocation];
    [appDelegate showtabView];
    [datasPicker removeFromSuperview];
    
//To get current timezone
    NSDateFormatter *localTimeZoneFormatter = [NSDateFormatter new];
    localTimeZoneFormatter.timeZone = [NSTimeZone localTimeZone];
    localTimeZoneFormatter.dateFormat = @"Z";
     NSString * localTimeZoneOffset = [localTimeZoneFormatter stringFromDate:[NSDate date]];
    NSMutableString *modifiedOffset = [localTimeZoneOffset mutableCopy];

    
    [modifiedOffset insertString:@"." atIndex:3];

    User *userData = appDelegate.appdelegateUser;
    NSMutableDictionary  *localDict=[[NSMutableDictionary alloc] init];
    [localDict setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
    [localDict setValue:locationId forKey:@"LocationId"];
    [localDict setValue:[NSNumber numberWithBool:TRUE] forKey:@"IsAutoStrikeOn"];
    [localDict setValue:dateSelectedPicker forKey:@"AutoStrikeAlarmDate"];
    [localDict setValue:modifiedOffset forKey:@"TimezoneDiff"];
    
    [modifiedOffset release];
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp postParseInfoWithUrlPath:KConfigureAutoStrikeAlarm WithSelector:selector callerClass:self parameterDic:localDict showloader:NO];
    
    
    
    leftBarButton.enabled=TRUE;
}

- (IBAction)hybridButtonAction:(id)sender
{
    self.hybridCheckBox = !self.hybridCheckBox;
    if (self.hybridCheckBox == TRUE)
    {
        
        [hybridImageViews setImage:[UIImage imageNamed:@"check_unselect.png"]];
        // here for standard map
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSNumber numberWithBool:0] forKey:checkMapStyle];
        [userDefault synchronize];

        
    }else
    {
        [hybridImageViews setImage:[UIImage imageNamed:@"check.png"]];
        // here for hybrid map
        NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[NSNumber numberWithBool:1] forKey:checkMapStyle];
        [userDefault synchronize];

    }
    
    
    
    
}

#pragma mark- picker delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arrayOfMyFavData count];
}


#pragma mark- picker delegate


//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    
//    NSLog(@" --------------  %@",[arrayOfMyFavData objectAtIndex:row]);
//    
//    Location* loc = (Location*)[arrayOfMyFavData objectAtIndex:row];
//    
//    [stringLocation setString:[NSString stringWithFormat:@"%@",loc.LocationName]];
//    [locationId setString:[NSString stringWithFormat:@"%d",loc.LocationId]];
//    //hidden_lbl.text = [NSString stringWithFormat:@"%@, %@",hidden_lbl.text,[arrayOfMyFavData objectAtIndex:row]];
//    
//    
//    
//}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
     Location* loc = (Location*)[arrayOfMyFavData objectAtIndex:row];
     return loc.LocationName;
}

-(void)getupdateResponseMyFav:(NSDictionary*)response{
    
    
    
    if ([[response objectForKey:kStatus] isKindOfClass:[NSNull class]]) {
        return;
    }
    
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        return;
    }
    else if(![[response valueForKey:@"LocationList"]isKindOfClass:[NSNull class]])
    {
        for (int i =0; [[response valueForKey:@"LocationList"] count]>i; i++)
        {
            Location *location = [[Location alloc] initWithNode:[[[response valueForKey:@"LocationList"] objectAtIndex:i] mutableCopy]];
            [locationArray addObject:location];
            [location release];
        }
        if (arrayOfMyFavData) {
            [arrayOfMyFavData release];
            arrayOfMyFavData = nil;
        }
        
        arrayOfMyFavData = [[NSMutableArray alloc] initWithArray:locationArray];
        
        if (arrayOfMyFavData != 0) {
            //add picker
            Location *firstLoc= [arrayOfMyFavData objectAtIndex:0];
              
            [stringLocation setString:[NSString stringWithFormat:@"%@",firstLoc.LocationName]];
            [dataPickers reloadAllComponents];
        }
        
       
        //here user set the alarms
        
        //[appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
    }
    
}

-(void)getupdateResponse:(NSDictionary*)response{
    
    
    
    if ([[response objectForKey:kStatus] isKindOfClass:[NSNull class]]) {
        return;
    }
    
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        return;
    }else
    {
                
        //here user set the alarms
        
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
    }
    
}
#pragma mark About
- (IBAction)about:(id)sender
{
    AboutViewController *viewContorller= [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:viewContorller animated:YES];
    [viewContorller release];
}


@end
