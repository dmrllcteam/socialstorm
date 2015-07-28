//
//  MKAnnotationView+Rotate.h
//  SocialRadar
//
//  Created by Amrit Pandey on 27/06/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKAnnotationView (Rotate)

@property(nonatomic, retain) UIImageView* imgView;

-(void)rotate;

@end
