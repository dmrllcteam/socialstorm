
//
//  NuyeekWebService.m
//  Nuyeek
//
//  Created by Sanjiv Saran on 02/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NuyeekWebService.h"
#import "SBJSON.h"
#import "NSString+SBJSON.h"
#import "SBJsonParser.h"
#import "CJSONDeserializer.h"
//#import "NuyeekAppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AppDelegate.h"
//#import "Constant.h"
//#import "FirstViewController.h"
#import "AppDelegate.h"




@implementation NuyeekWebService

@synthesize connection,responseData;

-(void) getParseInfoWithUrlPath:(NSString*)urlPath WithSelector:(SEL)selector callerClass:(id)caller parameterDic:(NSMutableDictionary *)parameterDic showloader:(BOOL)showloaders
{
    // if(showloader)
    // [APPDELEGATE showLoader];
    showloader = showloaders;
    if(showloader)
    {
        [appDelegate startAnimatingIndicatorView];
    }
    
    NSMutableString *prams = [[[NSMutableString alloc] init] autorelease];
    NSString *removeLastChar =nil;
    
    for (id keys in parameterDic)
    {
        [prams appendFormat:@"%@=%@&",keys,[parameterDic objectForKey:keys]];
    }
    
    NSString *urlString = nil;
    
    if (parameterDic) {
        removeLastChar = [prams substringWithRange:NSMakeRange(0, [prams length]-1)];
        urlString = [NSString stringWithFormat:@"%@?%@",urlPath, removeLastChar];
    }else
    {
        removeLastChar = [prams substringWithRange:NSMakeRange(0, 0)];
        urlString = [NSString stringWithFormat:@"%@%@",urlPath, removeLastChar];
    }
   
   // NSString *urlString = [NSString stringWithFormat:@"%@?%@",urlPath, removeLastChar];
    
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *myInitialRequest = [ASIHTTPRequest requestWithURL:url];
    myInitialRequest.delegate = self;
    callerMethod=selector;
    callerDelegate=caller;
    [myInitialRequest startAsynchronous];
}


-(void) PostParseInfoWithUrlPath:(NSString*)urlPath WithSelector:(SEL)selector callerClass:(id)caller parameterDic:(NSMutableDictionary *)parameterDic showloader:(BOOL)showloaders
{
     showloader = showloaders;
     if(showloader)
     {
         [appDelegate startAnimatingIndicatorView];
     }
    
    // NSString* arrayJson=[[[SBJSON alloc]init] stringWithObject:parameterDic error:nil];
    
    NSData *jsonData = nil;
    NSString *jsonString = nil;
    
    if([NSJSONSerialization isValidJSONObject:parameterDic])
    {
        jsonData = [NSJSONSerialization dataWithJSONObject:parameterDic options:0 error:nil];
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
      //  NSLog(@"post data :- %@", jsonString);
    }
    NSURL *url = [NSURL URLWithString:urlPath];
    
    /*[self.connection cancel];
     
     NSMutableData *data = [[NSMutableData alloc] init];
     self.responseData = data;
     [data release];
     
     NSURL *url = [NSURL URLWithString:urlPath];
     NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
     [theRequest setHTTPMethod:@"POST"];
     [theRequest setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
     [theRequest setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
     
     [theRequest setHTTPBody:jsonData];
     
     //Create the connection with the request, and start loading data.
     //theConnection will be released by connectionDidFinishLoading
     NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
     self.connection = theConnection;
     [theConnection release];
     
     //start the connection
     [connection start];*/
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    [request addRequestHeader:[NSString stringWithFormat:@"%d", [jsonData length]]  value:@"Content-Length"];
    //in low network
    [request setTimeOutSeconds:20];
    [request appendPostData:jsonData];
    [request setDelegate:self];
   //  NSLog(@"post data is %@",[request postBody]);
    callerMethod=selector;
    callerDelegate=caller;
    [request startAsynchronous];
    
}


//usablecodes
/*- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data
 {
 NSLog(@"didReceiveData");
 [self.responseData appendData:data];
 }
 //
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection
 {
 NSLog(@"data is %d",[self.responseData length]);
 NSLog(@"didFinishLoading");
 NSError *jsonParsingError = nil;
 NSArray *json = [NSJSONSerialization
 JSONObjectWithData:self.responseData
 options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments
 error:&jsonParsingError];
 
 NSLog(@"error is %d",[jsonParsingError code]);
 }
 
 
 - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
 {
 NSLog(@"didFailWithError");
 NSLog(@"%@" , error);
 }
 */




-(void)requestFailed:(ASIHTTPRequest *)request
{
    [appDelegate stopAnimatingIndicatorView];
    
    if(showloader)
    {
        [appDelegate stopAnimatingIndicatorView];
    }
	NSError *error = [request error];
	NSLog(@"requestFailed:%@",error);
    
    // [APPDELEGATE hideLoader];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Not Available" message:@"Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    
    if(showloader)
    {
        [appDelegate stopAnimatingIndicatorView];
    }

   // NSLog(@"Response %d ==> %@", request.responseStatusCode, [request responseString]);
    
    NSString *receivedString = [[NSString alloc]  initWithData:[request responseData] encoding:NSUTF8StringEncoding];
    
    NSLog(@"--- receivedString --- %@ --",receivedString);
    
    
    if(request.responseStatusCode == 200)
    {
        NSDictionary *data=[[request responseString] JSONValue];
        
        if(callerMethod)
        {
            [callerDelegate performSelector:callerMethod
                                 withObject:data];
            // [callerDelegate release];
            callerDelegate=nil;
            callerMethod=nil;
        }
    }else
    {
        [appDelegate stopAnimatingIndicatorView];
    }
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	
    if (buttonIndex == 0)
    {
        
        //exit(0);
    }
}


@end
