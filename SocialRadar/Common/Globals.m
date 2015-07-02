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

@synthesize SSGVenueSearchRadius = _venuesearch;
@synthesize NearByLocationRadius = _nearbylocationradius;
@synthesize SearchViewRadius = _searchviewradius;

-(id) init
{
    if(self = [super init])
    {
        self.SSGVenueSearchRadius = [NSNumber numberWithFloat:19312.128];  // HomeViewControler GetUpdateResponse
        self.NearByLocationRadius = [NSNumber numberWithFloat:19312.128];  // NearByLoactonViewControler
        self.SearchViewRadius = [NSNumber numberWithFloat:19312.128];
    }
    return self;
};
   
@end


