//
//  User.h
//  SocialRadar
//
//  Created by Mohit Singh on 18/06/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
{
    int _Age;
	NSDecimalNumber* _CreatedDate;
	NSString* _EmailAddress;
	NSString* _Gender;
	int _LargestStorm;
	NSDecimalNumber* _Latitude;
	NSString* _Message;
	NSString* _Name;
	NSString* _Password;
	NSString* _PhoneNo;
	NSString* _Photo;
	int _RegisterType;
	NSString* _RelationshipStatus;
	NSString* _Status;
	int _TotalStrikes;
	int _TotalStrom;
	int _UserId;
	NSString* _UserName;
	NSDecimalNumber* _longitude;
    NSMutableArray *_FavourateLocationList;
    Boolean _ActiveStatus;
    NSMutableString *_AutoStrikeInfoDetail;

}

@property int Age;
@property (retain, nonatomic) NSDecimalNumber* CreatedDate;
@property (retain, nonatomic) NSMutableArray *FavourateLocationList;
@property (retain, nonatomic) NSString* EmailAddress;
@property (retain, nonatomic) NSString* Gender;
@property int LargestStorm;
@property (retain, nonatomic) NSDecimalNumber* Latitude;
@property (retain, nonatomic) NSString* Message;
@property (retain, nonatomic) NSString* Name;
@property (retain, nonatomic) NSString* Password;
@property (retain, nonatomic) NSString* PhoneNo;
@property (retain, nonatomic) NSString* Photo;
@property int RegisterType;
@property (retain, nonatomic) NSString* RelationshipStatus;
@property (retain, nonatomic) NSString* Status;
@property int TotalStrikes;
@property int TotalStrom;
@property int UserId;
@property (retain, nonatomic) NSString* UserName;
@property (retain, nonatomic) NSDecimalNumber* longitude;
@property(nonatomic,readwrite)Boolean ActiveStatus;
@property(nonatomic,retain)NSMutableString * AutoStrikeInfoDetail;

- (id) initWithDict: (NSDictionary*) node;
@end
