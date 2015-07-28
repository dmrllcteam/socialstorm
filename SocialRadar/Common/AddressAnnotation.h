//
//  AddressAnnotation.h
//
//
//  Created by prakash raj on 25/07/11.
//  Copyright 2011 RRInnovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Location;
@interface AddressAnnotation : NSObject<MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
	
    NSString *title;
	NSString *subtitle;
    NSString * eventMyIDs;
    NSString *categoryID;
    NSString *imageUrl;
    
    UIImageView *image1;
    
    NSInteger strikeNo;
    NSInteger tag;

    Location* location;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *eventMyIDs;
@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy)  UIImageView *image1;
@property (nonatomic, retain)  NSString *imageUrl;
@property (nonatomic, readwrite) NSInteger tag;
@property (nonatomic, readwrite) NSInteger strikeNo;
@property (nonatomic, retain) Location* location;

@end
