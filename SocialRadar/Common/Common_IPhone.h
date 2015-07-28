//
//  Common_IPhone.h
//  SocialRadar
//
//  Created by Mohit Singh on 07/05/13.
//  Copyright (c) RRInovation LLC. All rights reserved.
//

//#ifndef SocialRadar_Common_IPhone_h
//#define SocialRadar_Common_IPhone_h
//
//
//
//#endif

#include "TargetConditionals.h"

#define KIsFaceBookLogIn    @"IsFaceBookLogIn"
#define kLoasderHeight 480
#define kLoasderWidth 320

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

// DAJ 20150723
// Search Radius
#define _WIDE_SEARCH_RADIUS 24140.16        // HomeViewController GetUpdateResponse
#define _NEARBY_SEARCH_RADIUS 3218.688      // HomeViewController
#define _SEARCHVIEW_SEARCH_RADIUS 19312.123 //SearchViewController


//#define kLaunchScreen @"LaunchScreen"
//#define kViewController @"ViewController"
#define kLoginViewControler @"LoginViewController"
#define kRegisterViewControler @"RegisterViewController"

//#define kEditProfileViewController @"EditProfileViewController"
#define kHallOfFrameViewController @"HallOfFrameViewController"
//#define kHomeViewController @"HomeViewController"
#define kMyProfileViewController @"MyProfileViewController"
#define kSettingViewController @"SettingViewController"
#define kSearchViewController @"SearchViewController"
#define KLocationDetailViewController @"LocationDetailViewController"
#define KNearByLocationViewControlerViewController @"NearByLocationViewControlerViewController"

#define kShareStrikeViewController @"ShareStrikeViewController"
#define kShareViewController @"ShareViewController"
#define kSearchDetailViewController @"SearchDetailViewController"
#define kAboutViewController @"AboutViewController"
#define kMessage @"Message"
#define kStatus  @"Status"
#define kLocationList @"LocationList"

#define checkMapStyle @"Standard_Hybrid"


#define _RELEASE(x) if(x){[x release]; x = nil;}

// DEFINE THE ARRAYs TO SHOW THE DATA


#define registerArrays  [[NSArray alloc] initWithObjects:@"Name",@"Age",@"Email",@"Username",@"Password",@"Relationship Status",@"Gender",@"Phone Number",@"Photo", nil]

#define relationShipArray  [[NSArray alloc] initWithObjects:@"Single",@"In a relationship",nil]
//#define relationShipArray  [[NSArray alloc] initWithObjects:@"Single",@"Married",nil]
#define genderArray  [[NSArray alloc] initWithObjects:@"Male",@"Female",nil]

#define searchImg  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_icn" ofType:@"png"]]
#define RadarImg  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"radar_btn" ofType:@"png"]]
#define recordsIconImg  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"records_icn" ofType:@"png"]]
#define filterIconImg  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"filter" ofType:@"png"]]
#define navigationImg  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"navbar" ofType:@"png"]]
#define homeTittle_IMG  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"navbar" ofType:@"png"]]
#define tabCustom_Img  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabbar" ofType:@"png"]]
#define tabStrikeButtonActive  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"strike_btn_pressed" ofType:@"png"]]
#define tabStrikeButtonInActive  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"strike_button" ofType:@"png"]]
#define editMyProfile  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edit_btn" ofType:@"png"]]
#define backImg [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_btn" ofType:@"png"]]
