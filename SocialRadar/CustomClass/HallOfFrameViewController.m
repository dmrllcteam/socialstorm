//
//  HallOfFrameViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 21/05/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import "HallOfFrameViewController.h"
#import "HallOfFrameViewCell.h"
#import "LocationDetailViewController.h"
#import "Common_IPhone.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "Location.h"
#import "CLXURLConnection.h"

#import "User.h"

@interface HallOfFrameViewController ()

@end

@implementation HallOfFrameViewController

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
    
    self.title = @"Records";
    self.navigationItem.hidesBackButton = YES;
    
    UIImage* buttonImage1 = [UIImage imageNamed:@"back_btn.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
    [leftButton setImage:buttonImage1 forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=back_btn;
    [back_btn release];

    
//    hallOfFrame_tableView.layer.cornerRadius=10.0;
//    hallOfFrame_tableView.layer.borderWidth=2.0;
//    hallOfFrame_tableView.layer.borderColor=[[UIColor colorWithWhite:1.0 alpha:2] CGColor];
//    hallOfFrame_tableView = [[UITableView alloc] initWithFrame:CGRectMake( 20, 30, 280, 337) style:UITableViewStyleGrouped];
//    hallOfFrame_tableView.dataSource = self;
//    hallOfFrame_tableView.delegate = self;
//    
//    
//    
//    hallOfFrame_tableView.backgroundColor = [UIColor clearColor];
//    hallOfFrame_tableView.opaque = YES;
//    
//    [self.view addSubview:hallOfFrame_tableView];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [appDelegate startAnimatingIndicatorView];
    User *userData = appDelegate.appdelegateUser;
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
    
    
   
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp getParseInfoWithUrlPath:KGetHallFameList WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
    }

-(void)backTarget:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [hallOfFrame_tableView release];
    [hallOfFarame_Cell release];
    [super dealloc];
}
- (void)viewDidUnload {
    [hallOfFrame_tableView release];
    hallOfFrame_tableView = nil;
    [hallOfFarame_Cell release];
    hallOfFarame_Cell = nil;
    [super viewDidUnload];
}

#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response{
    
        if([[response objectForKey:kStatus] isKindOfClass:[NSNull class]])
        {
            [appDelegate stopAnimatingIndicatorView];
            [appDelegate showAlertMessage:@" No Data" tittle:nil];
            return;
        }
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate stopAnimatingIndicatorView];
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        return;
    }else
    {
      //  [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
    }
   
    
    if (arrayOfStrorm)
    {
        [arrayOfStrorm release];
         arrayOfStrorm = nil;
    }
    arrayOfStrorm = [[NSMutableArray alloc] init];
    
    NSMutableArray *arrayOfLocationList = [response objectForKey:kLocationList];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"TotalStrom"
                                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedArray = [arrayOfLocationList sortedArrayUsingDescriptors:sortDescriptors];
    
    for (int i =0; i< [sortedArray count]; i++)
    {
        Location *location = [[Location alloc] initWithNode:[sortedArray objectAtIndex:i]];
        [arrayOfStrorm addObject:location];
        [location release];
    }

    
    [hallOfFrame_tableView reloadData];
    [appDelegate stopAnimatingIndicatorView];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [arrayOfStrorm count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableIdentifierOne";
    
    Location *location = [arrayOfStrorm objectAtIndex:indexPath.row];
    
    hallOfFarame_Cell = (HallOfFrameViewCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (hallOfFarame_Cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HallOfFrameViewCell" owner:self options:nil];
        // [registerTableViewCell setNeedsDisplay];
        hallOfFarame_Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger rows = indexPath.row + 1;

    hallOfFarame_Cell.label_cell.text = [NSString stringWithFormat:@"%i.  %@",rows,location.LocationName];
    hallOfFarame_Cell.stornImage_cell.image = [UIImage imageNamed:@"storm_icn.png"];
    
    //hallOfFarame_Cell = [[HallOfFrameViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    
    return hallOfFarame_Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Location *location = [arrayOfStrorm objectAtIndex:indexPath.row];
    
    
    LocationDetailViewController *locationDeatails = [[LocationDetailViewController alloc] initWithNibName:KLocationDetailViewController bundle:nil];
    locationDeatails.isFromHallOfFrame = YES;
    locationDeatails.locationObj = [location retain];
    [self.navigationController pushViewController:locationDeatails animated:YES];
    
}

@end
