#import "PluginManager.h"
#import <CoreLocation/CoreLocation.h>

@interface GeoLocPlugin : GCPlugin<CLLocationManagerDelegate>
@property (nonatomic, retain) CLLocationManager *locationMgr;
@property (nonatomic, retain) CLLocation *lastLocation;
@property (nonatomic, assign) bool requested;
@property (nonatomic, retain) NSDate *lastRequestTimestamp;

- (void)getNewLocation;
@end

