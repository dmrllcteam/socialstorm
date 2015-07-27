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
    NSNumber* _venuesearch;
    NSNumber* _global2;
    NSNumber* _global3;
    
    
}

@property (assign) NSNumber* SSGVenueSearch;
@property (assign) NSNumber* NearByLatitude;
@property (assign) NSNumber* SSGlobal3;

    
@end
#endif
