//
//  ShareStrikeViewController.m
//  SocialRadar
//
//  Created by Mohit Singh on 21/06/13.
//  Copyright (c) RRInnovation LLC. All rights reserved.
// https://developers.facebook.com/docs/ios/upgrading#30to31

#import "ShareStrikeViewController.h"
#import "Location.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "ShareViewController.h"
#import "Common_IPhone.h"
#import "User.h"
#import "HomeViewController.h"

@interface ShareStrikeViewController ()

@end

@implementation ShareStrikeViewController
@synthesize location,postParams;

static bool checkShareTweet;

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
    
    checkShareTweet = true;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"Share strike";
    
    self.navigationItem.hidesBackButton = YES;
    
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0,RadarImg.size.width, RadarImg.size.height);
    [leftButton setImage:RadarImg forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backTarget:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back_btn =[[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=back_btn;
    [back_btn release];
    
}


-(void)getfaceBookId:(NSNotificationCenter *)notif
{
    [APPDELEGATE hidetabView];
    ShareViewController *viewController =[[ShareViewController alloc] initWithNibName:kShareViewController
                                                                               bundle:nil];
     NSString *text_str=[NSString stringWithFormat:@"%@ shared his strike at %@ with SocialStorm.",appDelegate.appdelegateUser.UserName,location.LocationName];
   viewController.post_text_str=text_str;
    [self presentViewController:viewController
                       animated:YES
                     completion:nil];
}




-(void)viewDidUnload{
}

-(void)backTarget:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark Facebook Publish Method

-(IBAction)facebookAction:(id)sender
{

    [self shareButtonFaceBookClicked];
    
}

- (void)shareButtonFaceBookClicked {
   // Ask for publish_actions permissions in context
    [appDelegate startAnimatingIndicatorView];
   [FBSession.activeSession closeAndClearTokenInformation];
    if (!FBSession.activeSession.isOpen) {
        // Permission hasn't been granted, so ask for publish_actions
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                             if (FBSession.activeSession.isOpen && !error) {
                                                 // Publish the story if permission was granted
                                                 [self publishStory];
                                                 
                                           }
                                             
                                             else{
                                                 NSLog(@"Error");
                                             }
                                         }];
        
       
    } else {
        // If permissions present, publish the story
        [self publishStory];
    }
    
 
}




-(void)requestPublishPermissions
{
    
    if (FBSession.activeSession.isOpen)
    {
    [FBSession.activeSession requestNewPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                          defaultAudience:FBSessionDefaultAudienceFriends
                                        completionHandler:^(FBSession *session, NSError *error) {
                                            __block NSString *alertText;
                                            __block NSString *alertTitle;
                                            if (!error) {
                                                if ([FBSession.activeSession.permissions
                                                     indexOfObject:@"publish_actions"] == NSNotFound){
                                                    // Permission not granted, tell the user we will not publish
                                                    alertTitle = @"Permission not granted";
                                                    alertText = @"Your action will not be published to Facebook.";
                                                    [[[UIAlertView alloc] initWithTitle:alertTitle
                                                                                message:alertText
                                                                               delegate:self
                                                                      cancelButtonTitle:@"OK!"
                                                                      otherButtonTitles:nil] show];
                                                } else {
                                                    // Permission granted, publish the OG story
                                                    [self publishStory];
                                                }
                                                
                                            } else {
                                                // There was an error, handle it
                                                // See https://developers.facebook.com/docs/ios/errors/
                                            }
                                        }];
    }
}


- (void)publishStory
{
    NSString *userName;
    if (appDelegate.appdelegateUser.Name.length>0) {
        userName=appDelegate.appdelegateUser.Name;
    } else {
        userName=appDelegate.appdelegateUser.UserName;
    }
    NSString *text_str=[NSString stringWithFormat:@"%@ shared a strike at %@ with SocialStorm.",userName,location.LocationName];
 
    if (FBSession.activeSession.isOpen) {
        
      NSMutableDictionary *dict=[[NSMutableDictionary alloc] initWithObjectsAndKeys:
        text_str, @"message",
        @"http://itunes.apple.com/app/id940999298", @"link",
         nil, @"picture",
         "SocialStorm", @"name",
         nil, @"caption",
         text_str, @"description",
                 nil];
       
        [FBRequestConnection
         startWithGraphPath:@"me/feed"
         parameters:dict
         HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             
             NSString *alertText;
             if (error) {
                 
                 alertText = [NSString stringWithFormat:
                              @"Facebook is not allowing Posting on you Timeline Currently.Please try after some time!!"
                              ];
                 
                 
             }
             else {
                 alertText = @"Message Posted Succesfully";
             }
             
             UIAlertView  *textalert=[[UIAlertView alloc] initWithTitle:@"" message:alertText delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [textalert show];
             
             [appDelegate stopAnimatingIndicatorView];
             
         }];
        
 
   }
    
}

#pragma mark
#pragma mark Twitter Publish Method

-(IBAction)twitterAction:(id)sender
{
    NSString *userName;
    if (appDelegate.appdelegateUser.Name.length>0)
    {
        userName=appDelegate.appdelegateUser.Name;
    } else
    {
        userName=appDelegate.appdelegateUser.UserName;
    }
    
    NSString *text_str=[NSString stringWithFormat:@"%@ shared a strike at %@ with SocialStorm.",userName,location.LocationName];

// DAJ 20150622 update section replacing deprecated TW methods to use Social framework
//    if ([TWTweetComposeViewController canSendTweet])
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController* tweetSheet =[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter ];
        [tweetSheet setInitialText:text_str];

        // DAJ 20150622 replace above deprecated method
        [self presentViewController:tweetSheet animated:YES completion:nil];
        
        tweetSheet.completionHandler = ^(TWTweetComposeViewControllerResult result)
        {
            //NSString *title = @"Tweet";
            NSString *msg = nil;
            
            if (checkShareTweet)
            {
                if (result == TWTweetComposeViewControllerResultCancelled)
                {
                    msg = @"You bailed on your tweet...";
                }
                else if (result == TWTweetComposeViewControllerResultDone)
                {
                    msg = @"Tweet Posted Successfully.";
                    checkShareTweet = false;
                   // [self performSelector:@selector(testFunctions) withObject:self afterDelay:.2];
                    
                }
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alertView show];
                _RELEASE(alertView);
                
                
            }
            
           
            
//            [self dismissModalViewControllerAnimated:YES];
            // DAJ 20150622 replace above deprecated method
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
        _RELEASE(tweetSheet);

    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil,nil];
        [alertView show];
        [alertView release];
    }
}
#pragma mark dont share
- (IBAction)dontshare:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    for(UIViewController *vc in [self.navigationController viewControllers])
    {
        if([vc isKindOfClass:[HomeViewController class]])
        {
            [self.navigationController popToViewController:vc animated:NO];
        }
    }
    
}

@end
