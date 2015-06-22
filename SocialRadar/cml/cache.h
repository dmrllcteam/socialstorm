//
//  cache.h
//  LibraryDemo
//
//  Created by CM on 28/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface cache :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * value;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSDate * updationTime;

@end



