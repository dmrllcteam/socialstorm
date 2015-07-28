//
//  AddressAnnotation.m
//  NEWDUBAI
//
//  Created by prakash raj on 25/07/11.
//  Copyright 2011 RRInnovation LLC. All rights reserved.
//

#import "AddressAnnotation.h"


@implementation AddressAnnotation
@synthesize coordinate,title,subtitle,categoryID,tag;
@synthesize image1,imageUrl;
@synthesize eventMyIDs;
@synthesize strikeNo;
@synthesize location;

-(void)dealloc 
{
    [image1 removeFromSuperview];
    
    [title release];
    [subtitle release];
    [eventMyIDs release];
    [categoryID release];
    [image1 release];
    [super dealloc];
}
@end
