//
//  NearByLocation.m
//  SocialRadar
//
//  Created by Mohit Singh on 20/06/13.
//  Copyright (c) 2013 RRInnovation LLC. All rights reserved.
//

#import "NearByLocation.h"
#import "Foursquare2.h"
#import "UIImage+Base64Image.h"

@implementation NearByLocation
@synthesize dictGeometry = _dictGeometry;
@synthesize logitude = _logitude;
@synthesize latitude = _latitude;
@synthesize photos_Refrence = _photos_Refrence;
@synthesize contact_Refrence = _contact_Refrence;
@synthesize locationName = _locationName;


- (id) init
{
    if(self = [super init])
    {
        self.dictGeometry = nil;
        self.logitude = nil;
        self.latitude = nil;
        self.photos_Refrence = nil;
        self.contact_Refrence = nil;
        self.locationName = nil;
    }
    return self;
}



- (id) initWithDict: (NSDictionary*) dictonary
{
    self.latitude = [[dictonary valueForKey:@"location"] valueForKey:@"lat"];
    self.logitude = [[dictonary valueForKey:@"location"] valueForKey:@"lng"];
    self.locationName = [dictonary valueForKey:@"name"];
    if ([[dictonary valueForKey:@"contact"] valueForKey:@"formattedPhone"]!=nil) {
        self.contact_Refrence = [self converToBase64:[[dictonary valueForKey:@"contact"] valueForKey:@"formattedPhone"]];
    }
    else
    {
        self.contact_Refrence = @"";
    }
    
    [Foursquare2 venueGetPhotos:[dictonary valueForKey:@"id"] limit:[NSNumber numberWithInteger:1] offset:nil callback:^(BOOL success, id result)
    {
        if (success)
        {
            NSDictionary *resultDictionry= result;
            NSArray *array=[[[resultDictionry objectForKey:@"response"] objectForKey:@"photos"]objectForKey:@"items"];
            
            if (array!=nil&&array.count)
            {
                NSDictionary *imageDict=[array objectAtIndex:0];
                self.photos_Refrence=[self converToBase64:[NSString stringWithFormat:@"%@%@%@",[imageDict objectForKey:@"prefix"],@"300x300",[imageDict objectForKey:@"suffix"]]];
               
            }
        }
        else
        {
             self.photos_Refrence=@"";
        }
    }];
    
    return self;
}

+ (NSString*)base64forData:(NSData*)theData
{
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3)
    {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++)
        {
            value <<= 8;
            
            if (j < length)
            {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}


-(NSString *)converToBase64:(NSString*)str
{
    //NSLog(@"before base 64=%@", str);
    NSString *base64String = nil;
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    base64String=[UIImage base64forData:data];
   // NSLog(@"after base64=%@",base64String);

    return base64String;
}

- (void) dealloc
{
    self.dictGeometry = nil;
    self.logitude = nil;
    self.latitude = nil;
    self.photos_Refrence = nil;
    self.contact_Refrence = nil;
    self.locationName = nil;
    [super dealloc];
}


@end
