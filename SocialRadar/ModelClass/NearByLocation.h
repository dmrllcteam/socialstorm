//
//  NearByLocation.h
//  SocialRadar
//
//  Created by Mohit Singh on 20/06/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NearByLocation : NSObject
{
    NSMutableDictionary *_dictGeometry;
    NSString *_logitude;
    NSString *_latitude;
    NSString *_photos_Refrence;
    NSString *_contact_Refrence;
    NSString *_locationName;
    
}

@property (nonatomic,retain) NSMutableDictionary *dictGeometry;
@property (nonatomic,retain) NSString *logitude;
@property (nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *photos_Refrence;
@property (nonatomic,retain) NSString *contact_Refrence;
@property (nonatomic,retain) NSString *locationName;


- (id) initWithDict: (NSDictionary*) dictonary;
+ (NSString*)base64forData:(NSData*)theData ;
@end
