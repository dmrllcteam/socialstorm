//
//  MyProfileViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 13/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Common_IPhone.h"
#import "EditProfileViewController.h"
#import "SettingViewCell.h"
#import "User.h"
#import "AppDelegate.h"
#import "Location.h"
#import "UIImage+Base64Image.h"
#import "LocationDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "CLXURLConnection.h"


@interface MyProfileViewController ()

@end

@implementation MyProfileViewController
@synthesize favorites_tableView,profileTableView;

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
    self.navigationController.navigationBarHidden = NO;
    
     self.navigationItem.title = @"My Profile";
//    userImage_imageView
    
   /* if (appDelegate.IsFaceBookLogin) {
        
        //appDelegate.profilePictureView.frame = userImage_imageView.frame;
        [userImage_imageView addSubview:appDelegate.profilePictureView];
    }*/
    
//    UINavigationBar *navBar = self.navigationController.navigationBar;
//    [navBar setBackgroundImage:navigationImg forBarMetrics:UIBarMetricsDefault];
    
    
    UIImage* buttonImage1 = editMyProfile;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame= CGRectMake(0, 0,buttonImage1.size.width, buttonImage1.size.height);
    [rightButton setImage:buttonImage1 forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(editTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=back_btn;
    [back_btn release];
    
    myProfile_ScrollView.contentSize =  CGSizeMake(320, 680);
    
    
    favorites_tableView.frame = CGRectMake(favorites_tableView.frame.origin.x, favorites_tableView.frame.origin.y, favorites_tableView.frame.size.width, SCREEN_WIDTH);

    
    UIButton *leftNavBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBarButton.frame = CGRectMake(0, 0,RadarImg.size.width, RadarImg.size.height);
    [leftNavBarButton setImage:RadarImg forState:UIControlStateNormal];
    [leftNavBarButton addTarget:self action:@selector(radarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton =[[UIBarButtonItem alloc] initWithCustomView:leftNavBarButton];
    self.navigationItem.leftBarButtonItem=leftBarButton;
    [leftBarButton release];
    
   // [relationShipStatus_lbl sizeToFit];
    
    
    
}


-(void)radarButtonClick:(id)Sender
{
    [appDelegate.tabBarController setSelectedIndex:1];
    [[[appDelegate.tabBarController viewControllers]objectAtIndex:1] popToRootViewControllerAnimated:NO];
}

-(void)viewDidAppear:(BOOL)animated
{


}

-(void)viewWillAppear:(BOOL)animated
{
    
    if (arrayOfLocationList) {
        [arrayOfLocationList release];
        arrayOfLocationList = nil;
    }
    
    [appDelegate startAnimatingIndicatorView];
    
    arrayOfLocationList = [[NSMutableArray alloc] init];
    
    User *userData = appDelegate.appdelegateUser;
    NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
    [localDoct setValue:[NSString stringWithFormat:@"%i",userData.UserId] forKey:@"UserId"];
   
    
    CLXURLConnection* temp = [[CLXURLConnection alloc] init];
    SEL selector = @selector(getupdateResponse:);
    [temp getParseInfoWithUrlPath:KGetUserDetails WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];

    

    
}

-(void)editTarget:(id)sender
{
    
    EditProfileViewController *edit = [[EditProfileViewController alloc] initWithNibName:@"EditProfileViewController" bundle:nil] ;
    edit.userData = appDelegate.appdelegateUser;
    [self.navigationController pushViewController:edit animated:YES];
    [edit release];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [userName_lbl release];
    [level_lbl release];
    [totalStrikes_lbl release];
    [sex_lbl release];
    [relationShipStatus_lbl release];
    [age_lbl release];
    [phoneNumber_lbl release];
    [emailAddress_lbl release];
    [userImage_imageView release];
    [favorites_tableView release];
    [myProfile_ScrollView release];
    [cell release];
    [larestStorm_lbl release];
    [totalStorm_lbl release];
    [super dealloc];
}
- (void)viewDidUnload {
    [userName_lbl release];
    userName_lbl = nil;
    [level_lbl release];
    level_lbl = nil;
    [totalStrikes_lbl release];
    totalStrikes_lbl = nil;
    [sex_lbl release];
    sex_lbl = nil;
    [relationShipStatus_lbl release];
    relationShipStatus_lbl = nil;
    [age_lbl release];
    age_lbl = nil;
    [phoneNumber_lbl release];
    phoneNumber_lbl = nil;
    [emailAddress_lbl release];
    emailAddress_lbl = nil;
    [userImage_imageView release];
    userImage_imageView = nil;
    [favorites_tableView release];
    favorites_tableView = nil;
    [myProfile_ScrollView release];
    myProfile_ScrollView = nil;
    [cell release];
    cell = nil;
    [larestStorm_lbl release];
    larestStorm_lbl = nil;
    [totalStorm_lbl release];
    totalStorm_lbl = nil;
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
    return [arrayOfLocationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Location *locationName = [[Location alloc] initWithNode:[arrayOfLocationList objectAtIndex:indexPath.row]];
    
    static NSString *CellIdentifier = @"tableIdentifierOne";
    
    
    cell = (SettingViewCell*)[tableView1 dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [[NSBundle mainBundle] loadNibNamed:@"SettingViewCell" owner:self options:nil];
        // [registerTableViewCell setNeedsDisplay];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.setting_lbl.text = [NSString stringWithFormat:@"%@",locationName.LocationName];
    
    cell.imageView.image = [UIImage imageNamed:@"favorited_icn.png"];
    
    cell.fav_btnOutlet.tag = indexPath.row;
    
    [cell.fav_btnOutlet addTarget:self action:@selector(callDeselctFunction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
      Location *location = [[Location alloc] initWithNode:[arrayOfLocationList objectAtIndex:indexPath.row]];
    
    NSLog(@" location --- %@",location);
    
    LocationDetailViewController *locationDeatails = [[LocationDetailViewController alloc] initWithNibName:@"LocationDetailViewController" bundle:nil];
    locationDeatails.isFromHallOfFrame = NO;
    locationDeatails.locationObj = location ;
    [self.navigationController pushViewController:locationDeatails animated:YES];
    
    [location release];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}


-(void)getFavResponse:(NSDictionary*)response{
    
    [appDelegate stopAnimatingIndicatorView];
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        return;
    }else
    {
        //[appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        [appDelegate showAlertMessage:@"Unfavorited successfully" tittle:nil];
    }
    
    
}


-(void)callDeselctFunction:(id)sender
{
    UIButton *bttn = (UIButton *)sender;
    
        Location *locationName = [[Location alloc] initWithNode:[arrayOfLocationList objectAtIndex:bttn.tag]];
        User *usersData = appDelegate.appdelegateUser;
        NSMutableDictionary  *localDoct=[[NSMutableDictionary alloc] init];
        [localDoct setValue:[NSString stringWithFormat:@"%i",locationName.LocationId] forKey:@"LocationId"];
        [localDoct setValue:[NSString stringWithFormat:@"%i",usersData.UserId] forKey:@"UserId"];
        [localDoct setValue:[NSNumber numberWithBool:FALSE] forKey:@"IsFavorite"];
    
        [appDelegate startAnimatingIndicatorView];
    
        CLXURLConnection* temp = [[CLXURLConnection alloc] init];
        SEL selector = @selector(getFavResponse:);
        [ temp postParseInfoWithUrlPath:KUnFavoriteLocation WithSelector:selector callerClass:self parameterDic:localDoct showloader:NO];

    
        [arrayOfLocationList removeObjectAtIndex:bttn.tag];
        favorites_tableView.scrollEnabled = NO;
        CGRect favTableRect = favorites_tableView.frame;
        favTableRect.size.height = 44* ([arrayOfLocationList count] +1);
    
    
        CGRect profileTableRect = profileTableView.frame;
        profileTableRect.size.height = favTableRect.origin.y + favTableRect.size.height;
        profileTableView.frame = profileTableRect;
    
         favorites_tableView.frame = favTableRect;
    
        [myProfile_ScrollView setContentSize:CGSizeMake(320, profileTableRect.origin.y + profileTableRect.size.height + 30)];
        [favorites_tableView reloadData];

    
}

#pragma mark WEBSERVICEHANDLERS

-(void)getupdateResponse:(NSDictionary*)response
{
    
    [appDelegate stopAnimatingIndicatorView];
    
    if(![[response objectForKey:kStatus] isEqualToString:@"SUCCESS"])
    {
        [appDelegate showAlertMessage:[response objectForKey:kMessage] tittle:nil];
        
    }else
    {
        User *userData = [[User alloc] initWithDict:response];
        
        userName_lbl.text = userData.Name;
        //The User Level System – based on the # of storms not strikes Author Sanjay
        level_lbl.text = [self giveStrikeSymbolOnBasisOfStrike:userData.TotalStrom];
        totalStrikes_lbl.text = [NSString stringWithFormat:@"%i",userData.TotalStrikes];
        
        if ([[userData.Gender uppercaseString] isEqualToString:@"F"]) {
             sex_lbl.text = @"Female" ;
        }else if([[userData.Gender uppercaseString] isEqualToString:@"M"])
        {
             sex_lbl.text = @"Male" ;
        }
        
        if ([[userData.RelationshipStatus uppercaseString] isEqualToString:@"S"])
        {
            relationShipStatus_lbl.text = @"Single";
        }
        else if([userData.RelationshipStatus isEqualToString:@"I"])
        {
            //relationShipStatus_lbl.text = @"Married" ;
            relationShipStatus_lbl.text = @"Taken" ;
         
          
//            CGSize maximumLabelSize = CGSizeMake(55,32);
//            
//            // use font information from the UILabel to calculate the size
//            CGSize expectedLabelSize = [relationShipStatus_lbl.text sizeWithFont:relationShipStatus_lbl.font constrainedToSize:maximumLabelSize lineBreakMode:NSLineBreakByWordWrapping];
//            
//            // create a frame that is filled with the UILabel frame data
//            CGRect newFrame = relationShipStatus_lbl.frame;
//            
//            // resizing the frame to calculated size
//            newFrame.size.height = expectedLabelSize.height;
//            
//            // put calculated frame into UILabel frame
//            relationShipStatus_lbl.frame = newFrame;
        }
       
        //        age_lbl.text = [NSString stringWithFormat:@"%i",userData.Age];
        NSString *stringAges = [NSString stringWithFormat:@"%i",userData.Age];
        
        if ([stringAges isEqualToString:@"0"])
        {
         age_lbl.text = @"";
        }else
        {
            age_lbl.text = [NSString stringWithFormat:@"%i",userData.Age];
        }
        
        phoneNumber_lbl.text = userData.PhoneNo;
        emailAddress_lbl.text = userData.EmailAddress;
        larestStorm_lbl.text = [self giveStrikeSymbolOnBasisOfTotalStrike:userData.LargestStorm];
        
        totalStorm_lbl.text =[NSString stringWithFormat:@"%i",userData.TotalStrom];
        
        if ([userData.Photo length] != 0) {
            //userImage_imageView.image = [UIImage imageWithData:[UIImage base64DataFromString:userData.Photo]];
            
            UIImage* loadingImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"no_image" ofType:@"png"]];
            
            [userImage_imageView setImageWithURL:[NSURL URLWithString:userData.Photo] placeholderImage:nil success:^(UIImage* img){
                
                [userImage_imageView setImage:img];
                                
            } failure:^(NSError* err){
                
                
                [userImage_imageView setImage:loadingImage];
            }];
            
            [appDelegate.profilePictureView removeFromSuperview];
        }
        else if(appDelegate.IsTwitterLogin)
        {
           //userImage_imageView.image = appDelegate.twitterProfileImg;
            //Author : Sanjay Cropping the image
            userImage_imageView.image = appDelegate.twitterProfileImg;//[self imageByScalingAndCroppingForSize:appDelegate.twitterProfileImg :CGSizeMake(userImage_imageView.frame.size.width, userImage_imageView.frame.size.height)];
        }
        else if (appDelegate.IsFaceBookLogin) {
            
            //appDelegate.profilePictureView.frame = userImage_imageView.frame;
            [userImage_imageView addSubview:appDelegate.profilePictureView];
        }
        else
        {
         userImage_imageView.image = [UIImage imageNamed:@"no_image.png"];   
        }
        
        
        
        if(userData.FavourateLocationList)
        arrayOfLocationList = userData.FavourateLocationList;
        
        
        // sorting
        NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"LocationName" ascending:YES];
       arrayOfLocationList=  [[NSMutableArray alloc]initWithArray:[arrayOfLocationList sortedArrayUsingDescriptors:[NSArray arrayWithObjects:aSortDescriptor, nil]]];
        // sorting
    
        favorites_tableView.scrollEnabled = NO;
        CGRect favTableRect = favorites_tableView.frame;
        favTableRect.size.height = 44* ([arrayOfLocationList count] +1);
        
        
        CGRect profileTableRect = profileTableView.frame;
        profileTableRect.size.height = favTableRect.origin.y + favTableRect.size.height;
        profileTableView.frame = profileTableRect;
        
        
        favorites_tableView.frame = favTableRect;
        
        //[favorites_tableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.0];
        
        [myProfile_ScrollView setContentSize:CGSizeMake(320, profileTableRect.origin.y + profileTableRect.size.height + 30)];
        
        [favorites_tableView reloadData];
        
        
        }
}

//#pragma mark cropping the image
-(UIImage *) imageByScalingAndCroppingForSize:(UIImage *)inImage : (CGSize ) cropImageSize
{
    CGSize targetSize = cropImageSize;
    UIImage *sourceImage = inImage;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}


/*The User Level System – based on the # of storms not strikes Author Sanjay
 Novice (0-10 storms) 
 Experienced (11-30 storms) 
 Hero (31-60 storms) Master 
 (61-100 storms) 
 Legend (100+ storms)
 */

-(NSMutableString *)giveStrikeSymbolOnBasisOfStrike:(int)intStrike
{
    NSMutableString *strgStrikeSymbol = [[[NSMutableString alloc] init] autorelease];
    
     if (intStrike <= 10)
    {
        [strgStrikeSymbol setString:@"Novice"];
    }else if (intStrike <= 30)
    {
        [strgStrikeSymbol setString:@"Experienced"];
        
    }else if (intStrike <= 60)
    {
        [strgStrikeSymbol setString:@"Hero"];
        
    }else if (intStrike <= 100)
    {
        [strgStrikeSymbol setString:@"Master"];
        
    }else if (intStrike > 100)
    {
        [strgStrikeSymbol setString:@"Legend"];
    }
    
    
    
    
    
    /*if (intStrike == 0)
    {
        [strgStrikeSymbol setString:@""];
    }else if (intStrike <= 11)
    {
        [strgStrikeSymbol setString:@"Novice"];
    }else if (intStrike <= 30)
    {
        [strgStrikeSymbol setString:@"Experienced"];
        
    }else if (intStrike <= 60)
    {
        [strgStrikeSymbol setString:@"Hero"];
        
    }else if (intStrike <= 100)
    {
        [strgStrikeSymbol setString:@"Master"];
        
    }else if (intStrike > 100)
    {
        [strgStrikeSymbol setString:@"Legend"];
    }*/
    
    return strgStrikeSymbol;
}
/*  
 Storm Level System – this is currently at the correct scale in the app
 EF0 (20-85 strikes)
 EF1 (86-110 strikes) 
 EF2 (111-135 strikes) 
 EF3 (136-165 strikes) 
 EF4 (166-200 strikes)
 EF5 – (201-299 strikes) 
 EF6 – (300+ strikes)
 Author:Sanjay
*/
-(NSMutableString *)giveStrikeSymbolOnBasisOfTotalStrike:(int)intStrike
{
    NSMutableString *strgStrikeSymbol = [[[NSMutableString alloc] init] autorelease];
    
    if (intStrike < 20) {
        
        [strgStrikeSymbol setString:@""];
    }else if (intStrike <= 85)
    {
        [strgStrikeSymbol setString:@"EF0"];
        
    }else if (intStrike <= 110)
    {
        [strgStrikeSymbol setString:@"EF1"];
        
    }else if (intStrike <= 135)
    {
        [strgStrikeSymbol setString:@"EF2"];
        
    }else if (intStrike <= 165)
    {
        [strgStrikeSymbol setString:@"EF3"];
        
    }else if (intStrike <= 200)
    {
        [strgStrikeSymbol setString:@"EF4"];
        
    }else if (intStrike <= 299)
    {
        [strgStrikeSymbol setString:@"EF5"];
        
    }else if (intStrike > 300)
    {
        [strgStrikeSymbol setString:@"EF6"];
        
    }
    
    return strgStrikeSymbol;
}



@end
