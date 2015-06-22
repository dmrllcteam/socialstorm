//
//  User.m
//  SocialRadar
//
//  Created by Mohit Singh on 18/06/13.
//  Copyright (c) 2013 Mohit Singh. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize Age = _Age;
@synthesize CreatedDate = _CreatedDate;
@synthesize EmailAddress = _EmailAddress;
@synthesize Gender = _Gender;
@synthesize LargestStorm = _LargestStorm;
@synthesize Latitude = _Latitude;
@synthesize Message = _Message;
@synthesize Name = _Name;
@synthesize Password = _Password;
@synthesize PhoneNo = _PhoneNo;
@synthesize Photo = _Photo;
@synthesize RegisterType = _RegisterType;
@synthesize RelationshipStatus = _RelationshipStatus;
@synthesize Status = _Status;
@synthesize TotalStrikes = _TotalStrikes;
@synthesize TotalStrom = _TotalStrom;
@synthesize UserId = _UserId;
@synthesize UserName = _UserName;
@synthesize longitude = _longitude;
@synthesize FavourateLocationList = _FavourateLocationList;
@synthesize ActiveStatus = _ActiveStatus;
@synthesize AutoStrikeInfoDetail = _AutoStrikeInfoDetail;

- (id) init
{
    if(self = [super init])
    {
        self.CreatedDate = nil;
        self.EmailAddress = nil;
        self.Gender = nil;
        self.Latitude = nil;
        self.Message = nil;
        self.Name = nil;
        self.Password = nil;
        self.PhoneNo = nil;
        self.Photo = nil;
        self.RelationshipStatus = nil;
        self.Status = nil;
        self.UserName = nil;
        self.longitude = nil;
        self.FavourateLocationList = nil;
        self.AutoStrikeInfoDetail=nil;
        
    }
    return self;
}

- (id) initWithDict: (NSDictionary*) node
{
        self.Age = [[node objectForKey: @"Age"] intValue];
        self.EmailAddress = [node objectForKey: @"EmailAddress"];
        self.Gender = [node objectForKey: @"Gender"];
        self.LargestStorm = [[node objectForKey: @"LargestStorm"] intValue];
        self.Message = [node objectForKey: @"Message"];
        self.Name = [node objectForKey: @"Name"];
        
        self.PhoneNo = [node objectForKey: @"PhoneNo"];
        self.Photo = [node objectForKey: @"Photo"];
        self.RegisterType = [[node objectForKey: @"RegisterType"] intValue];
        self.RelationshipStatus = [node objectForKey: @"RelationshipStatus"];
        self.Status = [node objectForKey: @"Status"];
        self.TotalStrikes = [[node objectForKey: @"TotalStrikes"] intValue];
        self.TotalStrom = [[node objectForKey: @"TotalStrom"] intValue];
        self.UserId = [[node objectForKey: @"UserId"] intValue];
        self.UserName = [node objectForKey: @"UserName"];
        self.ActiveStatus =[[node objectForKey:@"ActiveUser"]boolValue];
    
    if (![[node objectForKey: @"AutoStrikeInfoDtl"] isKindOfClass: [NSNull class]]) {
        self.AutoStrikeInfoDetail = [node objectForKey:@"AutoStrikeInfoDtl"];
     }
   
        if (![[node objectForKey: @"FavourateLocationList"] isKindOfClass: [NSNull class]]) {
         self.FavourateLocationList = [node objectForKey: @"FavourateLocationList"];
         }
    
        if (![[node objectForKey: @"Password"] isKindOfClass: [NSNull class]]) {
        self.Password = [node objectForKey: @"Password"];
        }else
        {
           self.Password = @"";
        }

    
       
        return self;
}

- (void) dealloc
{
    self.CreatedDate = nil;
    self.EmailAddress = nil;
    self.Gender = nil;
    self.Latitude = nil;
    self.Message = nil;
    self.Name = nil;
    self.Password = nil;
    self.PhoneNo = nil;
    self.Photo = nil;
    self.RelationshipStatus = nil;
    self.Status = nil;
    self.UserName = nil;
    self.longitude = nil;
    self.FavourateLocationList = nil;
    self.AutoStrikeInfoDetail=nil;
    [super dealloc];
}


@end
