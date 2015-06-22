//
//  NuyeekWebService.h
//  Nuyeek
//
//  Created by Sanjiv Saran on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


//#define BASEURL @"http://182.71.82.92/SocialRadar/SocialRadarService.svc/"
//#define BASEURL @"http://10.91.0.201/SocialRadar/SocialRadarService.svc/"
//#define BASEURL @"http://182.71.82.92/SocialRadar/SocialRadarService.svc?wsdl"

//#define BASEURL @"http://socialradarservice.cloudapp.net/SocialRadarService.svc/"
//#define BASEURL @"http://socialradar.cloudapp.net/SocialRadarService.svc/"
#define BASEURL @"http://03bcc7d.netsolhost.com/SocialStormServices/SocialRadarService.svc/"  


#define KGetUserDetails [NSString stringWithFormat:@"%@GetUserDetails",BASEURL]
#define KSaveUser [NSString stringWithFormat:@"%@SaveUser",BASEURL] 
#define KAuthenticateUser [NSString stringWithFormat:@"%@AuthenticateUser",BASEURL]
#define KGetLocationListWithStrikeCountAndTotalStrom [NSString stringWithFormat:@"%@GetLocationListWithStrikeCountAndTotalStrom",BASEURL]
#define KSaveStrikeDetails [NSString stringWithFormat:@"%@SaveStrikeDetails",BASEURL]
#define KGetHallFameList [NSString stringWithFormat:@"%@GetHallFameList",BASEURL]
#define KGetLocationDetail [NSString stringWithFormat:@"%@GetLocationDetail",BASEURL]
#define KSaveAsFavoriteLocation [NSString stringWithFormat:@"%@SaveAsFavoriteLocation",BASEURL]
#define KUnFavoriteLocation [NSString stringWithFormat:@"%@UnFavoriteLocation",BASEURL]
#define KGetFaveoriteLocation [NSString stringWithFormat:@"%@GetFaveoriteLocation",BASEURL]
#define KGetUserDetails [NSString stringWithFormat:@"%@GetUserDetails",BASEURL]
#define KConfigureAutoStrikeAlarm [NSString stringWithFormat:@"%@ConfigureAutoStrikeAlarm",BASEURL]
#define KUpdateUser [NSString stringWithFormat:@"%@UpdateUser",BASEURL]
#define KUserStatus [NSString stringWithFormat:@"%@UserStatus",BASEURL]
#define KSignUpWitFacebookOrTwitter [NSString stringWithFormat:@"%@SignUpWitFacebookOrTwitter",BASEURL]



@interface NuyeekWebService : NSObject<UIAlertViewDelegate>
{
    id                                      callerDelegate;
    SEL                                     callerMethod;
    BOOL                                    showloader;
}

@property(strong,nonatomic)NSMutableData *responseData;
@property(strong,nonatomic)NSURLConnection *connection;
-(void) getParseInfoWithUrlPath:(NSString*)urlPath WithSelector:(SEL)selector callerClass:(id)caller parameterDic:(NSMutableDictionary *)parameterDic showloader:(BOOL)showloaders;
-(void) PostParseInfoWithUrlPath:(NSString*)urlPath WithSelector:(SEL)selector callerClass:(id)caller parameterDic:(NSMutableDictionary *)parameterDic showloader:(BOOL)showloaders;

@end
