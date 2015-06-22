//
//  CacheManager.h
//  iCruiseApp
//
//  Created by Cadile on 16/12/09.
//  Copyright 2009 Office. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "cache.h"


@interface CacheManager : NSObject {
	sqlite3 *database;
	NSString *dbName;
	NSString *DBPath;
	NSUserDefaults *userDefaults;

	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
}
-(void)initilize;
-(NSInteger) cacheSize;
-(void)deleteCacheDataForKey:(NSString*)key;
-(void)emptyCache;
-(void)vacuumData;
-(NSDate *)lastUpdateDateForKey:(NSString *)key;
-(BOOL)doesDataExistForKey:(NSString *)key;
-(void)setData:(NSData *)data forKey:(NSString *)key;
-(void)updateData:(NSData *)data forKey:(NSString *)key;
-(void)insertData:(NSData *)data forKey:(NSString *)key;
-(NSData *)getDataForKey:(NSString *)key;

- (NSString *)applicationDocumentsDirectory;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@end
