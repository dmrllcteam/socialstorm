//
//  CLXURLConnection.h
//  WannaChat
//
//  Created by Mohit Singh on 11/09/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//  http://wannachat.cloudapp.net/WannaChat.svc


//#define BASEURL @"http://182.71.82.92/SocialRadar/SocialRadarService.svc/"
//#define BASEURL @"http://10.91.0.201/SocialRadar/SocialRadarService.svc/"
//#define BASEURL @"http://182.71.82.92/SocialRadar/SocialRadarService.svc?wsdl"

//#define BASEURL @"http://socialradarservice.cloudapp.net/SocialRadarService.svc/"
//#define BASEURL @"http://socialradar.cloudapp.net/SocialRadarService.svc/"
#define BASEURL @"http://03bcc7d.netsolhost.com/SocialStormServices/SocialRadarService.svc/"


#define KGetUserDetails [NSString stringWithFormat:@"%@GetUserDetails",BASEURL]//Done
#define KSaveUser [NSString stringWithFormat:@"%@SaveUser",BASEURL]//Done
#define KAuthenticateUser [NSString stringWithFormat:@"%@AuthenticateUser",BASEURL]//Done
#define KGetLocationListWithStrikeCountAndTotalStrom [NSString stringWithFormat:@"%@GetLocationListWithStrikeCountAndTotalStrom",BASEURL]//Done
#define KSaveStrikeDetails [NSString stringWithFormat:@"%@SaveStrikeDetails",BASEURL]//Done
#define KGetHallFameList [NSString stringWithFormat:@"%@GetHallFameList",BASEURL]//Done
#define KGetLocationDetail [NSString stringWithFormat:@"%@GetLocationDetail",BASEURL]
#define KSaveAsFavoriteLocation [NSString stringWithFormat:@"%@SaveAsFavoriteLocation",BASEURL]//Done
#define KUnFavoriteLocation [NSString stringWithFormat:@"%@UnFavoriteLocation",BASEURL]//Done
#define KGetFaveoriteLocation [NSString stringWithFormat:@"%@GetFaveoriteLocation",BASEURL]//Done
#define KGetUserDetails [NSString stringWithFormat:@"%@GetUserDetails",BASEURL]//Done
#define KConfigureAutoStrikeAlarm [NSString stringWithFormat:@"%@ConfigureAutoStrikeAlarm",BASEURL]
#define KUpdateUser [NSString stringWithFormat:@"%@UpdateUser",BASEURL]//Done
#define KUserStatus [NSString stringWithFormat:@"%@UserStatus",BASEURL]//Done
#define KSignUpWitFacebookOrTwitter [NSString stringWithFormat:@"%@SignUpWitFacebookOrTwitter",BASEURL]//Done


#import <Foundation/Foundation.h>

@protocol CXConnectionDelegate <NSObject>
-(void)didReceiveCLXURLResponse:(id)object methodName:(NSString*)methodName;


@end

@interface CLXURLConnection : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    id                                      callerDelegate;
    SEL                                     callerMethod;
     BOOL                                    showloader;
   
}
@property(nonatomic, weak) id <CXConnectionDelegate> delegate;


-(void)getParseInfoWithUrlPath:( __unsafe_unretained NSString*)urlPath WithSelector:(SEL)selector callerClass:(id)caller parameterDic:( __unsafe_unretained NSMutableDictionary *)parameterDic showloader:(BOOL)showloaders;

-(void)postParseInfoWithUrlPath:( __unsafe_unretained NSString*)urlPath WithSelector:(SEL)selector callerClass:(id)caller parameterDic:( __unsafe_unretained NSMutableDictionary *)parameterDic showloader:(BOOL)showloaders;



@end
