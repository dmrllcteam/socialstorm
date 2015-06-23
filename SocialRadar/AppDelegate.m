//
//  AppDelegate.m
//  SocialRadar
//
//  Created by Mohit Singh on 07/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//
//12 miles= 19312.08 meters
//50 miles= 80467.0
//1 mile =1609.344 meters

#import "AppDelegate.h"
#import "Common_IPhone.h"
#import "RXCustomTabBar.h"
#import "ViewController.h"
#import "Common_IPhone.h"
#import "HomeViewController.h"
#import "MyProfileViewController.h"
#import "SettingViewController.h"
#import <SystemConfiguration/SCNetworkReachability.h>   // This for ne
#include <netdb.h>
#import "LoginViewController.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "user.h"


//#import "TWSignedRequest.h"

//#import <FacebookSDK/FacebookSDK.h>


AppDelegate* appDelegate = nil;

@implementation AppDelegate
@synthesize strike_button,tab_view,appdelegateUser,twitterProfileImg,TwitterUserName,FaceBookArray,currentlocation,TwitterName,TwitterId;
@synthesize useraddress;

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
   // [strike_button release];
    [tab_view release];
    [TwitterName release];
    [TwitterId release];
    [TwitterUserName release];
    [twitterProfileImg release];
    [currentlocation release];
    [FaceBookArray release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //New Foursquare Trending API
    [Foursquare2 setupFoursquareWithClientId:@"DTX0XHI2TIOWZ4WBWOZBZHZM3S4K3THBWUWX5K25J3HYNA5D"
                                      secret:@"T4Q5ZCH1HGMZ5XI3WM1IR0KA2B0PX12N22QMCHNOJAFZZ1X5"
                                 callbackURL:@"SocialRadar://foursquare"];
    //end
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:[NSNumber numberWithBool:1] forKey:checkMapStyle];
    [userDefault synchronize];
    self.useraddress = [[NSMutableString alloc] init];
    
    // unitialize locaiton services
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    // DAJ 20150620 new location services check to see if IOS 8 gaurd agains unkown selector in IOS 7
    if([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [locationManager requestWhenInUseAuthorization];
//        [locationManager requestAlwaysAuthorization];
    }
    
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManager startUpdatingLocation];
    
    appDelegate = self;
    [FBProfilePictureView class];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
   
    self.viewController = [[[ViewController alloc] initWithNibName:kViewController bundle:nil] autorelease];
    UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController=navigation;
    
    [self showLoaderView];
    // Override point for customization after application launch.
  
//    UIViewController *viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
//    UIViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
//    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
//    self.tabBarController.viewControllers = @[viewController1, viewController2];
//    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    if(loaderView != nil)
    {
        [loaderView removeFromSuperview];
    }
    _RELEASE(loaderView);
    _RELEASE(activityIndicatorView);

}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/





-(void)createTabView
{
    
//   [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//   [UIColor whiteColor], UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    
    //  Added by Rich: code that changes the selected color of UI items ex:profile, settings, ect
    // DAJ 20150623 replace above deprecated UITextAttributeColor
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

    
    [UITabBarItem.appearance setTitleTextAttributes:
     @{NSForegroundColorAttributeName : [UIColor whiteColor]}
                                           forState:UIControlStateSelected];
//  End of added code
    
//  Added by Rich: code that changes text color of nav bar titles
    [[UINavigationBar appearance] setTitleTextAttributes:@ {NSForegroundColorAttributeName : [UIColor whiteColor]}];
//  End of added code
    
//  Added by Rich: code that makes all TableViews translucent and changes their font colors
    [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewCell class], nil]
     setTextColor:[UIColor whiteColor]];
//  End of added code
    
//  Added by Rich :code that enables the top toolbar to continue behind the status bar and also makes status bar translucent
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
//  End of added code
    
    MyProfileViewController* myprofile = [[MyProfileViewController alloc] initWithNibName:kMyProfileViewController bundle:nil];
    UINavigationController* myprofileNavCtrller = [[UINavigationController alloc] initWithRootViewController:myprofile] ;
//    myprofileNavCtrller.tabBarItem.title = @"My Profile";
    [myprofileNavCtrller.navigationBar setBackgroundImage:navigationImg forBarMetrics:UIBarMetricsDefault];
//    UIImage* messageSelImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"profile_icn" ofType:@"png"]];
//   [myprofileNavCtrller.tabBarItem setImage:messageSelImage];
    
//  Added by Rich :code that sets the images to not be grey when unselected
    [myprofileNavCtrller.tabBarItem setImage:[[UIImage imageNamed:@"profile_icn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [myprofileNavCtrller.tabBarItem setSelectedImage:[[UIImage imageNamed:@"profile_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//  End of added code
    
    [myprofileNavCtrller.tabBarItem setTitle:@"Profile"];
    [myprofile release];
    
    
    HomeViewController* home = [[HomeViewController alloc] initWithNibName:kHomeViewController bundle:nil];
    home.view.backgroundColor=[UIColor blackColor];
    UINavigationController* homeNavCtrller = [[UINavigationController alloc] initWithRootViewController:home] ;
    [homeNavCtrller.navigationBar setBackgroundImage:homeTittle_IMG forBarMetrics:UIBarMetricsDefault];
     homeNavCtrller.navigationItem.hidesBackButton = YES;
    [home release];
    
    
    SettingViewController* setting = [[SettingViewController alloc] initWithNibName:kSettingViewController bundle:nil];
     UINavigationController* settingNavCtrller = [[UINavigationController alloc] initWithRootViewController:setting] ;
      [settingNavCtrller.navigationBar setBackgroundImage:navigationImg forBarMetrics:UIBarMetricsDefault];
//        UIImage* searchSelImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings_icn" ofType:@"png"]];
//      [settingNavCtrller.tabBarItem setImage:searchSelImage];
    // [settingNavCtrller.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"settings_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings_icn.png"]];
    
    //  Added by Rich :code that sets the images to not be grey when unselected
    [settingNavCtrller.tabBarItem setImage:[[UIImage imageNamed:@"settings_icn.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    [settingNavCtrller.tabBarItem setSelectedImage:[[UIImage imageNamed:@"settings_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    //  End of added code
    
    [settingNavCtrller setTitle:@"Settings"];
    [setting release];
    
    self.tabBarController = [[UITabBarController alloc] init] ;
    self.tabBarController.viewControllers = @[myprofileNavCtrller, homeNavCtrller,settingNavCtrller];
    [self.tabBarController setSelectedIndex:1];
    self.tabBarController.delegate=self;
    [self customizeInterface];
    [self.window addSubview:self.tabBarController.view];
    //self.window.rootViewController=self.tabBarController;
    
    tab_view=[[UIView  alloc] initWithFrame:CGRectMake(106.6, self.window.frame.size.height-60, 106.7, 74)];
    [tab_view setBackgroundColor:[UIColor clearColor]];
    strike_button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    
    User *userData = appDelegate.appdelegateUser;
    
    self.IsStrikeMade = userData.ActiveStatus;
   //self.IsStrikeMade=TRUE;
    
    if (self.IsStrikeMade) {
    [strike_button setImage:[UIImage imageNamed:@"strike_btn_release.png"] forState:UIControlStateNormal];
    }
    else
    {
    [strike_button setImage:[UIImage imageNamed:@"strike_button.png"] forState:UIControlStateNormal];
    }
    
    
    CGSize btn_size= CGSizeMake(58, 58);
    [strike_button setFrame:CGRectMake((tab_view.frame.size.width-btn_size.width)/2, 2, btn_size.width, btn_size.height)];
    [strike_button addTarget:self action:@selector(LoadhomeView:) forControlEvents:UIControlEventTouchUpInside];
    [tab_view addSubview:strike_button];
    
    [self.window addSubview:tab_view];
    
    //[self.window makeKeyAndVisible];
    
}


-(void)showtabView
{
    [tab_view setHidden:NO];
}

-(void)hidetabView
{
    [tab_view setHidden:YES];
}

- (void)customizeInterface

{
    //UIImage* tabBarBackground = [UIImage imageNamed:kTabBarBackgroundImage];
    
    [[UITabBar appearance] setBackgroundImage:tabCustom_Img];
    
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selection_blank.png"]];
    
    
}

-(void)LoadhomeView:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"SETLABEL" object:nil];

}

-(void)setbuttonImage:(BOOL)isUserStrikes
{
    if(isUserStrikes)
    {
        [strike_button setImage:[UIImage imageNamed:@"strike_btn_release.png"] forState:UIControlStateNormal];
    }
    else
        [strike_button setImage:[UIImage imageNamed:@"strike_button.png"] forState:UIControlStateNormal];
       
    // [[NSNotificationCenter defaultCenter] postNotificationName:@"SETLABEL" object:nil];
        
}

 

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    
    switch (tabBarController.selectedIndex)
    {
        case 0:
//            [viewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"profile_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"profile_icn.png"]];

            // DAJ 2015 replace deprecated setFinishedSeledImage
            [viewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"profile_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];// imageWithRederingMode:UIImageRenderingModeAlwaysOriginal ]];
            
            break;
            
        case 1:
            if (self.IsStrikeMade)
                {
                    [strike_button setImage:[UIImage imageNamed:@"strike_btn_release.png"] forState:UIControlStateNormal];
                }
                else
                {
//                    [viewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"strike_button.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"strike_button.png"]];

                    // DAJ 2015 replace deprecated setFinishedSeledImage
                    [viewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"strike_button.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
              
                }
            break;
            
        case 2:
//            [viewController.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"settings_active.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"settings_icn.png"]];

            // DAJ 2015 replace deprecated setFinishedSeledImage
            [viewController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"settings_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];

            
            break;
        default:
            break;
    }
    
    
}



#pragma mark ACTIVITYINDICATOR VIEW METHOD

- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return 0;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}


#pragma mark ALERTMESSAGE

-(void) showAlertMessage:(NSString *) message tittle:(NSString *) tittle
{
    UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:tittle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
    _RELEASE(errorAlert);
    
}


-(void)startAnimatingIndicatorView
{
    loaderView.hidden = NO;
    [self.window bringSubviewToFront:loaderView];
    [self performSelectorInBackground:@selector(startActivity)withObject:nil];
}


- (void) showLoaderView
{
    
    loaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, kLoasderHeight)];
    loaderView.backgroundColor = [UIColor blackColor];
    [loaderView setAlpha:0.7];
    
    //    UIImageView* backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    //    backGroundImageView.image = [UIImage imageNamed:@"bg.png"];
    //    [loaderView addSubview:backGroundImageView];
    //    [backGroundImageView release];
    //
    //    UILabel* loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 440, 200, 21)];
    //    loadingLabel.text= @"Please Wait...";
    //    loadingLabel.font= [UIFont systemFontOfSize:20];
    //    loadingLabel.textColor= [UIColor orangeColor];
    //    loadingLabel.backgroundColor = [UIColor clearColor];
    //    [loaderView addSubview:loadingLabel];
    //    [loadingLabel release];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.frame = CGRectMake((loaderView.frame.size.width-37)/2, (loaderView.frame.size.height-37)/2, 37, 37);
    [loaderView addSubview: activityIndicatorView];
    
    [self.window addSubview:loaderView];
    loaderView.hidden = YES;
}


-(void)startActivity
{
    [activityIndicatorView startAnimating];
}

-(void)stopAnimatingIndicatorView
{
    [activityIndicatorView stopAnimating];
    loaderView.hidden = YES;
}

#pragma mark
#pragma mark Facebook methods

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"email",@"user_about_me"
                        , nil];
 
   return [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      if(error)
                                      {
                                          [self stopAnimatingIndicatorView];
                                          NSLog(@"Session error");
                                         // [self fbResync];
                                          //[NSThread sleepForTimeInterval:0.5];
                                           UIAlertView *alertView =  [[UIAlertView alloc]
                                           initWithTitle:@"Error"
                                           message:@"Please check Facebook Account from phone settings."
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                                           [alertView show];
                                          
                                      }
                                      else
                                          [self sessionStateChanged:session state:state error:error];
                                  }];

    
    
}


-(void)fbResync
{
    
//        NSArray *fbAccounts = [accountStore accountsWithAccountType:accountTypeFB];
//        id account;
//        if (fbAccounts && [fbAccounts count] > 0 && (account = [fbAccounts objectAtIndex:0])){
//            
//            [accountStore renewCredentialsForAccount:account completion:^(ACAccountCredentialRenewResult renewResult, NSError *error) {
//                //we don't actually need to inspect renewResult or error.
//                if (error){
//                    
//                }
//                
//                else{
//                    
//                    NSArray *permissions = [[NSArray alloc] initWithObjects:@"public_profile",@"email",@"user_about_me"
//                                            , nil];
//                    [FBSession openActiveSessionWithReadPermissions:permissions
//                                                       allowLoginUI:YES
//                                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
//                                                      [self sessionStateChanged:session state:state error:error];
//                                                  }];
//                }
//               
//            }];
//        }}
}
/*
 *
 */
- (void) closeSession {
    [FBSession.activeSession closeAndClearTokenInformation];
}




- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    [self stopAnimatingIndicatorView];
    switch (state) {
        case FBSessionStateOpen: {
//            dispatch_async(dispatch_get_current_queue(), ^{
//                [self openSessionForPublishPermissions];
//            });
            [self getUserDetails];
            
            
        }
        break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
              [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    
    
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:@"Please check Facebook Account from phone settings."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


-(void)openSessionForPublishPermissions
{
   
    
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session, NSError *error)
     {
         if (!error)
         {
              [self getUserDetails];
         }
         else
         {
             
             [self stopAnimatingIndicatorView];
             NSLog(@"Session error");
             // [self fbResync];
             //[NSThread sleepForTimeInterval:0.5];
             UIAlertView *alertView =  [[UIAlertView alloc]
                                        initWithTitle:@"Error"
                                        message:@"Please check Facebook Account from phone settings."
                                        delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
             [alertView show];
        }
     }];
}



- (void)getUserDetails
{
    if (FBSession.activeSession.isOpen)
    {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error)
           {
             if (!error)
             {
                 NSLog(@"Username is %@",user.username);
                FaceBookArray = [[NSMutableArray alloc]init];
              [FaceBookArray insertObject:[user valueForKey:@"name"] atIndex:0];
              [FaceBookArray insertObject:[user valueForKey:@"email"] atIndex:1];
                 
                 if ([user valueForKey:@"username"])
                 {
                     [FaceBookArray insertObject:[user valueForKey:@"username"] atIndex:2];
                 }
                 else
                 {
                    [FaceBookArray insertObject:[user valueForKey:@"email"] atIndex:2]; 
                     
                 }
                 [FaceBookArray insertObject:[user valueForKey:@"gender"] atIndex:3];
                 [FaceBookArray insertObject:[user valueForKey:@"id"] atIndex:4];
                 
                 
                 
                 self.profilePictureView = [[FBProfilePictureView alloc] init];
                 self.profilePictureView.frame = CGRectMake(0.0, 0.0, 130, 153);
                 
                 // DAJ 20150622 change depricated id to objecID
                 self.profilePictureView.profileID = user.objectID;
                 [self startAnimatingIndicatorView];
                 [self.Loginobj LoginthroughFacebook];
             }
             else
             {
                 UIAlertView *alertView = [[UIAlertView alloc]
                                           initWithTitle:@"Error"
                                           message:error.localizedDescription
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
                 [alertView show];
             }
         }];
        
    /*    NSString *query =
        @"SELECT uid, name, pic_big,username,first_name,birthday_date,last_name,middle_name,email,sex,current_address,current_location,age_range,about_me FROM user WHERE uid = me() "
        ;
        
        
        // Set up the query parameter
        NSDictionary *queryParam =
        [NSDictionary dictionaryWithObjectsAndKeys:query, @"q", nil];
        // Make the API request that uses FQL
        [FBRequestConnection startWithGraphPath:@"/fql"
                                     parameters:queryParam
                                     HTTPMethod:@"GET"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
                                  if (error) {
                                   //   [APPDELEGATE hideLoader];
                                      NSLog(@"Error: %@", [error localizedDescription]);
                                  } else {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          //  NSLog(@"Result: %@", result);
                                         // [APPDELEGATE hideLoader];
                                          //Get the friend data to display
                                          NSArray *friendInfo = (NSArray *) [result objectForKey:@"data"];
                                         // [self FaceSignupCall:friendInfo];
                                      });
                                  }
                              }];*/


    }
}


/*
 * If we have a valid session at the time of openURL call, we handle
 * Facebook transitions by passing the url argument to handleOpenURL
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
    {
    // Handle incoming app links
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:FBSession.activeSession
                    fallbackHandler:^(FBAppCall *call)
                    {
                      
                    }];
    
    
       
}

#pragma mark --
#pragma mark Twitter Method



-(void)TwitterVerification
{
    
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error)
    {
            if (granted == YES)
            {
                NSArray *arrayOfAccounts = [account
                                            accountsWithAccountType:accountType];
                if (arrayOfAccounts>0) {
                    ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                    
                    NSURL *url =
                    //Author Sanjay : Changed version from 1 to 1.1
                    [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                    
                    NSDictionary *params = [NSDictionary dictionaryWithObject:twitterAccount.username
                                                                       forKey:@"screen_name"];
//                    TWRequest *request = [[TWRequest alloc] initWithURL:url
//                                                             parameters:params
//                                                          requestMethod:TWRequestMethodGET];

                    // DAJ 20150623 replace above deprecated TWRequest with SocialServices call
                    SLRequest* request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
                    
                    
                    request.account=twitterAccount;
                    
                    [request performRequestWithHandler:
                     ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                    {
                         
                         if (responseData)
                         {
                             NSDictionary *user =
                             [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingAllowFragments
                                                               error:NULL];
                             
                              dispatch_async(dispatch_get_main_queue(), ^{
                                 [self startAnimatingIndicatorView];
                                  self.TwitterId= [user objectForKey:@"id"];
                                 self.TwitterUserName = [user objectForKey:@"screen_name"];
                                 self.TwitterName = [user objectForKey:@"name"];
                                 NSString *profileImageUrl=nil;
                                 profileImageUrl=[user objectForKey:@"profile_image_url"];
                                 //Author Sanjay : picked profile image
                                 profileImageUrl=[profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
                                 NSData *imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:profileImageUrl]];
                                 self.twitterProfileImg = [UIImage imageWithData:imageData];
                                 
                                 [self.Loginobj LoginthroughTwitter];
                                 });
                         }
                     }];
                }
            }
    };
    
    
    
    
    //  This method changed in iOS6. If the new version isn't available, fall back to the original (which means that we're running on iOS5+).
    if ([account respondsToSelector:@selector(requestAccessToAccountsWithType:options:completion:)])
    {
        [account requestAccessToAccountsWithType:accountType options:nil completion:handler];
    }
    else
    {
//        [account requestAccessToAccountsWithType:accountType withCompletionHandler:handler];

        // DAJ replace facebook deprecated method above
        [account requestAccessToAccountsWithType:accountType options:nil completion:handler];
    }
    
    
//    [account requestAccessToAccountsWithType:accountType
//                                     options:nil completion:^(BOOL granted, NSError *error)
//     ];
    
}



-(void)TwitterLogin
{
//    if ([TWTweetComposeViewController canSendTweet])
    // DAJ 20150622 replace above depricated method use Social framwork
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        
        [self TwitterVerification];
    }
    else
    {
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"No Twitter Account"
                                      message:@"There is no Twitter account configured.You can add or create a Twitter account in Settings"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil,nil];
            [alertView show];
            
    }
    
[self performSelector:@selector(stopAnimatingIndicatorView) withObject:nil afterDelay:2];

}

#pragma mark- CLLocationDelegate

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    self.currentlocation = newLocation;
    //[locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:self.currentlocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             [self.useraddress setString:[[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "]];
                         
         }
         else
         {
             
             /*NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",newLocation.coordinate.latitude,newLocation.coordinate.longitude]];
              
              
              NSURLRequest* urlRequest = [NSURLRequest requestWithURL:url];
              [NSURLConnection sendAsynchronousRequest:urlRequest queue:operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
              //  NSLog(@"connection error=%@",connectionError);
              NSString* responseStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
              NSData *data2 = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
              id json = [NSJSONSerialization JSONObjectWithData:data2 options:0 error:nil];
              
              NSDictionary* dictResponse=json;
              if ([[dictResponse objectForKey:@"results"] count])
              {
              [self.useraddress setString:[[[dictResponse objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]];
              self.address = [NSString stringWithString:[[[dictResponse objectForKey:@"results"] objectAtIndex:0] objectForKey:@"formatted_address"]];
              }
              //  NSLog(@"response=%@",useraddress);
              [self.alertLocation dismissWithClickedButtonIndex:0 animated:YES];
              
              }];*/
             
             
         }
         
     }];

}
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if([error code] == 1)
    {
        
        [appDelegate.useraddress setString:@""];
    }
}
@end
