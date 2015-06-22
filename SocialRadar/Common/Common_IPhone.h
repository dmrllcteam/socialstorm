//
//  Common_IPhone.h
//  SocialRadar
//
//  Created by Mohit Singh on 07/05/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

//#ifndef SocialRadar_Common_IPhone_h
//#define SocialRadar_Common_IPhone_h
//
//
//
//#endif

#include "TargetConditionals.h"

#define KIsFaceBookLogIn    @"IsFaceBookLogIn"
#define HEIGHT_IPHONE_5 568
#define IS_IPHONE_5 ([[UIScreen mainScreen] bounds ].size.height == HEIGHT_IPHONE_5 )
#define kLoasderHeight (IS_IPHONE_5)? 568 : 480

#define kViewController (IS_IPHONE_5)? @"ViewController-5" : @"ViewController"
#define kLoginViewControler (IS_IPHONE_5)? @"LoginViewController-5" : @"LoginViewController"
#define kRegisterViewControler (IS_IPHONE_5)? @"RegisterViewController-5" : @"RegisterViewController"

#define kEditProfileViewController (IS_IPHONE_5)? @"EditProfileViewController-5" : @"EditProfileViewController"
#define kHallOfFrameViewController (IS_IPHONE_5)? @"HallOfFrameViewController-5" : @"HallOfFrameViewController"
#define kHomeViewController (IS_IPHONE_5)? @"HomeViewController-5" : @"HomeViewController"
#define kMyProfileViewController (IS_IPHONE_5)? @"MyProfileViewController-5" : @"MyProfileViewController"
#define kSettingViewController (IS_IPHONE_5)? @"SettingViewController-5" : @"SettingViewController"
#define kSearchViewController (IS_IPHONE_5)? @"SearchViewController-5" : @"SearchViewController"
#define KLocationDetailViewController (IS_IPHONE_5)? @"LocationDetailViewController-5" : @"LocationDetailViewController"
#define KNearByLocationViewControlerViewController (IS_IPHONE_5)? @"NearByLocationViewControlerViewController-5" : @"NearByLocationViewControlerViewController"

#define kShareStrikeViewController (IS_IPHONE_5)? @"ShareStrikeViewController-5" : @"ShareStrikeViewController"
#define kShareViewController (IS_IPHONE_5)? @"ShareViewController-5" : @"ShareViewController"
#define kSearchDetailViewController (IS_IPHONE_5)? @"SearchDetailViewController-5" : @"SearchDetailViewController"
#define kAboutViewController (IS_IPHONE_5)? @"AboutViewController-5" : @"AboutViewController"

#define kMessage @"Message"
#define kStatus  @"Status"
#define kLocationList @"LocationList"

#define checkMapStyle @"Standard_Hybrid"


#define _RELEASE(x)             if(x){[x release]; x = nil;}

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
#define homeTittle_IMG  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"socialradar_navicon" ofType:@"png"]]
#define tabCustom_Img  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tabbar" ofType:@"png"]]
#define tabStrikeButtonActive  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"strike_btn_pressed" ofType:@"png"]]
#define tabStrikeButtonInActive  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"strike_button" ofType:@"png"]]
#define editMyProfile  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"edit_btn" ofType:@"png"]]
#define backImg [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"back_btn" ofType:@"png"]]
