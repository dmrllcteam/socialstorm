//
//  AppDelegate.h
//  SocialRadar
//
//  Created by Mohit Singh on 07/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Foursquare2.h"
@class LoginViewController;

#define  APPDELEGATE (AppDelegate*)[[UIApplication sharedApplication]delegate]
@class ViewController, RXCustomTabBar, User;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, CLLocationManagerDelegate>
{
    CLLocation* currentlocation;
    UIView *loaderView;
    UIActivityIndicatorView *activityIndicatorView;
    User *appdelegateUser ;
    CLLocationManager* locationManager;
    
}

@property (strong, nonatomic) UIWindow           *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) ViewController     *viewController;
@property (strong, nonatomic) UIButton           *strike_button;
@property (strong, nonatomic) UIView             *tab_view;
@property (strong, nonatomic) User               *appdelegateUser ;
@property (strong,nonatomic)NSMutableArray *FaceBookArray;
@property(nonatomic,retain) NSString *TwitterUserName,*TwitterName;
@property(nonatomic,retain) NSString *TwitterId;
@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property (nonatomic,readwrite)bool IsFaceBookLogin, IsTwitterLogin;
@property(nonatomic, retain) CLLocation* currentlocation;
@property(strong,nonatomic)UIImage *twitterProfileImg;
@property(nonatomic,strong)LoginViewController *Loginobj;
@property(nonatomic,readwrite)bool IsStrikeMade;
@property(nonatomic,readwrite)bool IsFacebbookLogin;
@property (nonatomic, strong) NSMutableString * useraddress;


-(void)createTabView;
-(void)showtabView;
-(void)hidetabView;
- (BOOL) connectedToNetwork;
-(void)setbuttonImage:(BOOL)isUserStrikes;
-(void)showAlertMessage:(NSString *) message tittle:(NSString *) tittle;
-(void)startAnimatingIndicatorView;
-(void)stopAnimatingIndicatorView;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
-(void)TwitterLogin;



@end


extern AppDelegate* appDelegate;

