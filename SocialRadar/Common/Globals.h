//
//  Globals.h
//  SocialStorm
//
//  Copyright (c) RRInnovation LLC. All rights reserved.
//
//
//              History
//  Created by Dave Jarvis on 6/4/15.
//  DAJ add globals class 20150621

#ifndef SocialStorm_Globals_h
#define SocialStorm_Globals_h

#import <Foundation/Foundation.h>

@interface SSGlobals : NSObject 
{
    NSNumber* _venuesearchradius;
    NSNumber* _nearbylocationradius;
    NSNumber* _searchviewradius;
    
    
}

@property (retain, nonatomic) NSNumber* SSGVenueSearchRadius;
@property (retain, nonatomic) NSNumber* NearByLocationRadius;
@property (retain, nonatomic) NSNumber* SearchViewRadius;

    
@end
#endif
