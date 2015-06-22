//
//  PreserverdObject.h
//  Get BladderFit
//
//  Created by CM on 06/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheManager.h"


@interface PreserverdObject : NSObject {
	CacheManager *cacheManager;
}
@property(nonatomic,retain) CacheManager *cacheManager;

+ (PreserverdObject *)sharedInstance;
+(id)alloc;
-(void)addObject:(id)obj;
-(void)initilize;
-(NSMutableArray *)getDataForClass:(id)class;
-(void)removeAllObjectsForClass:(id)class;
-(void)removeObjectOfClass:(id)class AtIndex:(NSInteger)index;
-(void)removeObject:(id)object;
-(id)getObjectOfClass:(id)class AtIndex:(NSInteger)index;
-(void)replaceObject:(id)obj AtIndex:(NSInteger)index;


-(void)addObject:(id)obj forKey:(NSString *)key;
-(NSMutableArray *)getObjectsOfClass:(id)class forKey:(NSString *)key;
-(void)setObject:(id)obj forKey:(NSString *)key;
-(void)removeAllObjectsOfClass:(id)class forKey:(NSString *)key;
-(void)updateObject:(id)obj atIndex:(NSInteger)index forKey:(NSString *)key;
-(void)removeObjectatIndex:(NSInteger)index forKey:(NSString *)key forClass:(id)class;
-(NSMutableArray*)getAllKeysOfSavedObjectsForClass:(id)class;
-(NSMutableArray *)getAllKeyedObjectsOfClass:(id)class forKey:(NSString *)key;

@end
