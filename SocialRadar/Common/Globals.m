//
//  Globals.m
//  SocialStorm
//
//  Copyright (c) RRInnovation LLC. All rights reserved.
//
//          History
//  Created by Dave Jarvis on 6/8/15.
//  DAJ added globals class 20150621

#import <Foundation/Foundation.h>
#import "Globals.h"

@interface  SSGlobals()

@end

@implementation SSGlobals

@synthesize SSGVenueSearch = _venuesearch;
@synthesize NearByLatitude = _global2;
@synthesize SSGlobal3 = _global3;

-(id) init
{
    if(self = [super init])
    {
        self.SSGVenueSearch = [NSNumber numberWithFloat:19312.123];  // HomeViewControler GetUpdateResponse
        self.NearByLatitude = [NSNumber numberWithFloat:19312.123];  // HomeViewControler 
        self.SSGlobal3 = [NSNumber numberWithFloat:19312.123];
    }
    return nil;
};
   
    





@end


