//
//  requestData.h
//  iCruiseApp
//
//  Created by CM on 18/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//http://coppermobile.net/
//#define BASEURL  BASEURL@""
//#define BASE_URL  @"http://coppermobile.net/stateval/"
typedef enum
{
	REQUEST_TYPE_GET,
	REQUEST_TYPE_PUT,
	REQUEST_TYPE_POST
}RequestType;

typedef enum
	{
		REQUEST_DATA_FROM_CACHE,
		REQUEST_DATA_FROM_CACHE_AND_UPDATE_CACHE_IN_BACKGROUND,
		REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE,
		REQUEST_DATA_FROM_URL,
		REQUEST_DATA_FROM_CACHE_AND_URL,
		REQUEST_DATA_FROM_CACHE_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE,
		REQUEST_DATA_FROM_CACHE_IF_FAIL_THEN_REQUEST_DATA_FROM_URL_AND_UPDATE_CACHE
	}RequestSourceType;

typedef enum
	{
		RESPONSE_TYPE_STR,
		RESPONSE_TYPE_DATA,
		RESPONSE_TYPE_DICT
	}ResponseDataType;

typedef enum
	{
		RESPONSE_DATA_TYPE_CACHE,
		RESPONSE_DATA_TYPE_LIVE
	}ResponseType;

////////////////////////////////////
/////LHTContentManagementAPIs///////
////////////////////////////////////

@interface RequestData : NSObject {
	
	
	UIView *loaderView;
	NSString *baseURL;
	NSString *webServiceURL;
	id sender;
	RequestSourceType requestSourceType;
	RequestType requestType;
	ResponseDataType responseDataType;
	NSMutableDictionary *getData;
	NSMutableDictionary *postData;
	NSString *putData;
	id callbackObj;
	NSString *errorForNoNetwork;
	NSMutableDictionary *files;
	SEL callbackFunction;
	BOOL showLoader;
	SEL callbackFunctionOnError;
	NSString *username;
	NSString *password;

	id responseData;
	ResponseType responseType;
	BOOL wasCashedDataReturned;
	
	BOOL isZipped;
	BOOL runWithProxy;
	BOOL shouldPreserveIfFailed;
	NSString *proxyHostString;
	NSInteger proxyPort;
	NSDate *requestDateTime;
	
}

-(UIView *)initLoader;

//For Proxy Server.
@property(nonatomic) BOOL isZipped;
@property(nonatomic) BOOL shouldPreserveIfFailed;
@property(nonatomic,retain) NSString *username;
@property(nonatomic,retain) NSString *password;

@property(nonatomic,retain) NSString *proxyHostString;
@property(nonatomic,assign) NSInteger proxyPort;
@property(nonatomic,assign) BOOL runWithProxy;

@property(nonatomic,retain) UIView *loaderView;
@property(nonatomic,retain) NSString *baseURL;
@property(nonatomic,retain) NSString *webServiceURL;
@property(nonatomic,retain) NSString *errorForNoNetwork;
@property(nonatomic,retain) id sender;
@property(nonatomic,assign) RequestSourceType requestSourceType;
@property(nonatomic,assign) RequestType requestType;
@property(nonatomic,assign) ResponseDataType responseDataType;
@property(nonatomic,retain) NSMutableDictionary *getData;
@property(nonatomic,retain) NSMutableDictionary *postData;
@property(nonatomic,retain) NSString *putData;
@property(nonatomic,assign) id callbackObj;
@property(nonatomic,retain) NSMutableDictionary *files;
@property(nonatomic,assign) SEL callbackFunction;
@property(nonatomic,assign) SEL callbackFunctionOnError;
@property(nonatomic,assign) BOOL showLoader;

@property(nonatomic,assign) id responseData;
@property(nonatomic,assign) ResponseType responseType;
@property(nonatomic,assign) BOOL wasCashedDataReturned;

@property(nonatomic,retain) NSDate *requestDateTime;



@end
