//
//  SearchResultView.m
//  SocialRadar
//
//  Created by Mohit Singh on 02/07/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "SearchResultView.h"
#import "HallOfFrameViewCell.h"
#import "NearByLocation.h"
#import "Location.h"
#import "SearchDetailViewController.h"
#import "Common_IPhone.h"
#import "AppDelegate.h"
#import "User.h"
#import "CLXURLConnection.h"


@interface SearchResultView ()

@end

@implementation SearchResultView
@synthesize arrayOfTextSearch, hallOfFarame_Cell;

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
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Search Results";
    
    self.navigationItem.hidesBackButton = YES;
    
    UIImage* buttonImage1 = [UIImage imageNamed:@"back_btn.png"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
    [leftButton setImage:buttonImage1 forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=back_btn;
    [back_btn release];
    
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
    [textSearch_TableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [textSearch_TableView release];
    textSearch_TableView = nil;
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [arrayOfTextSearch count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableIdentifierOne";
    NearByLocation *nearByLocationsCellRow = [arrayOfTextSearch objectAtIndex:indexPath.row];
    
    hallOfFarame_Cell = (HallOfFrameViewCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (hallOfFarame_Cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"HallOfFrameViewCell" owner:self options:nil];
        // [registerTableViewCell setNeedsDisplay];
        hallOfFarame_Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger rows = indexPath.row + 1;
    
    hallOfFarame_Cell.label_cell.text = [NSString stringWithFormat:@"%i.  %@",rows,nearByLocationsCellRow.locationName];
    hallOfFarame_Cell.stornImage_cell.hidden = YES;
    hallOfFarame_Cell.bolt_imageView.hidden = YES;
    
    
    
    
    return hallOfFarame_Cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    nearByLocationsDidSelect = [arrayOfTextSearch objectAtIndex:indexPath.row];
    

    
    User *userData = appDelegate.appdelegateUser;

    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:nearByLocationsDidSelect.latitude forKey:@"Latitude"];
    [localDoct setValue:nearByLocationsDidSelect.logitude forKey:@"longitude"];
    [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
    
    [appDelegate startAnimatingIndicatorView];
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp postParseInfoWithUrlPath:KGetLocationDetail WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];
    
    
    
}

#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response{
    
    
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        Location *location = [[Location alloc] initWithNode:[response mutableCopy]];
        SearchDetailViewController *search = [[SearchDetailViewController alloc] initWithNibName:kSearchDetailViewController bundle:nil];
        search.locationObj = [nearByLocationsDidSelect retain];
        search.location = location;
        [search setBoolGoogle_Local:FALSE];
        [self.navigationController pushViewController:search animated:YES];
        [location release];
        
//        [appDelegate showAlertMessage:@"No strike made at this location" tittle:nil];
//        return;
    }else
    {
            Location *location = [[Location alloc] initWithNode:[response mutableCopy]];
            SearchDetailViewController *search = [[SearchDetailViewController alloc] initWithNibName:kSearchDetailViewController bundle:nil];
            search.locationObj = [nearByLocationsDidSelect retain] ;
             search.location = location;
            [search setBoolGoogle_Local:TRUE];
            [self.navigationController pushViewController:search animated:YES];

        
    }
}


/*
-(void)getupdateResponse:(NSDictionary*)response{
    
    
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        return;
    }else
    {
        Location *locationShow = [[Location alloc] initWithNode:[response mutableCopy]];
        
        location_Outlet.text = locationShow.LocationName;
        [self giveStrikeSymbolOnBasisOfStrike:locationShow.TotalStrike];
        level_Outlet.text = strgStrikeSymbol;
        totalStrike_Outlet.text = [NSString stringWithFormat:@"%i",locationShow.TotalStrike] ;
        total_Storm.text = [NSString stringWithFormat:@"%i",locationShow.TotalStrom];
        liveFeeds_M_outlet.text = [NSString stringWithFormat:@"%i (%i)",locationShow.TotalMale,locationShow.AverageMale];
        liveFeeds_F_Outlet.text = [NSString stringWithFormat:@"%i (%i)",locationShow.TotalFemale,locationShow.AverageFemale];
        avgAge_Outlet.text = [NSString stringWithFormat:@"%i",locationShow.AverageAge];
        
        [self giveStrikeSymbolOnBasisOfStrike:locationShow.LargestStrikeCount];
        largestStorm.text  = strgStrikeSymbol;
        largestStormDateTime.text = [NSString stringWithFormat:@"%@",locationShow.LargestStrikeCreatedDate];
        
        
        
        
        locationImageView.image = [UIImage imageNamed:@"no_image.png"];
        phoneNumber_Outlet.text = @"";
        emailAddress_Outlet.text = @"";
    }
}
*/

@end
