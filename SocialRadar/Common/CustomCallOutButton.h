//
//  CustomCallOutButton.h
//  TourtoTravelProj
//
//  Created by Neeraj Bhakuni on 1/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Location;
@interface CustomCallOutButton : UIButton
{
    Location* location;
}

@property(nonatomic, retain)Location* location;

@end
