//
//  SampleData.h
//  Get BladderFit
//
//  Created by CM on 06/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SampleData : NSObject {
	NSInteger age;
	NSString *name;
	BOOL isActive;
	NSDate *today;
}

@property(nonatomic) NSInteger age;
@property(nonatomic,retain) NSString *name;
@property(nonatomic) BOOL isActive;
@property(nonatomic,retain) NSDate *today;

@end
