#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Location;

@interface CalloutMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    
    NSInteger tag;
    
    Location* location;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic,readwrite) NSInteger tag;
@property (nonatomic, retain) Location* location;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude;

@end
