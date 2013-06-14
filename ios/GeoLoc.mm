#import "GeoLoc.h"

@implementation GeolocPlugin

// The plugin must call super dealloc.
- (void) dealloc {
    self.locationMgr = nil;
    self.lastLocation = nil;
	
	[super dealloc];
}

// The plugin must call super init.
- (id) init {
	self = [super init];
	if (!self) {
		return nil;
	}
	
	self.locationMgr = [[[CLLocationManager alloc] init] autorelease];
	self.locationMgr.desiredAccuracy = kCLLocationAccuracyBest;
	self.locationMgr.distanceFilter = kCLDistanceFilterNone;
	self.locationMgr.delegate = self;
	self.lastLocation = nil;
	self.started = false;
	
	return self;
}

- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	NSLOG(@"{geoloc} Error:", error);
}

- (void) locationManager:(CLLocationManager *)manager
     didUpdateToLocation:(CLLocation *)newLocation
            fromLocation:(CLLocation *)oldLocation {

	// If last location is not initialized,
    if (!self.lastLocation) {
		// Eat this update and wait for the next one
        self.lastLocation = newLocation;
    } else if (![newLocation.timestamp isEqualToDate:self.lastLocation.timestamp]) {
		// Accept the new location

		NSLOG(@"{geoloc} Got location");

		// If request is active,
		if (self.requested) {
			[[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
												  @"geoloc",@"name",
												  [NSNumber numberWithDouble:newLocation.coordinate.latitude],@"latitude",
												  [NSNumber numberWithDouble:newLocation.coordinate.longitude],@"longitude",
												  kCFBooleanFalse, @"failed",
												  nil]];
			self.lastRequestTimestamp = newLocation.timestamp;
			self.requested = false;

			// TODO: There seems to be a bug in the iOS location manager that requires us
			// to restart the location updates to do one-shots. -cat
			if (self.started) {
				[manager stopUpdatingLocation];
				self.started = false;
			}
		} else {
			// If position updates continue 43 seconds past the last request, then just stop updating
			if (!self.lastRequestTimestamp ||
				[newLocation.timestamp timeIntervalSinceDate:self.lastRequestTimestamp] >= 43) {
				if (self.started) {
					[manager stopUpdatingLocation];
					self.started = false;
				}
				NSLOG(@"{geoloc} Disabled position updates since requests have not been received for a while");
			}
		}
    }

	self.lastLocation = newLocation;
}

- (void) getNewLocation {
	self.requested = true;

	if (!self.started) {
    	[self.locationMgr startUpdatingLocation];
		self.started = true;
	}
}

- (void) initializeWithManifest:(NSDictionary *)manifest appDelegate:(TeaLeafAppDelegate *)appDelegate {
	NSLOG(@"{geoloc} Initialized with manifest");
}

- (void) onRequest:(NSDictionary *)jsonObject {
	@try {
		NSLOG(@"{geoloc} Got request");

		CLAuthorizationStatus authStatus = [CLLocationManager authorizationStatus];

		// If user has or may authorize use of GPS,
		if (authStatus == kCLAuthorizationStatusNotDetermined ||
				authStatus == kCLAuthorizationStatusAuthorized) {
			[self getNewLocation];

			// Additionally if the user is getting a prompt for this,
			if (authStatus == kCLAuthorizationStatusNotDetermined) {
				NSLOG(@"{geoloc} WARNING: User being prompted to request access. This geolocation request will be ignored if user denies access to GPS");
			}
		} else {
			[[PluginManager get] dispatchJSEvent:[NSDictionary dictionaryWithObjectsAndKeys:
				@"geoloc",@"name",
				kCFBooleanTrue, @"failed",
				nil]];
		}
	}
	@catch (NSException *exception) {
		NSLOG(@"{geoloc} Exception while processing event: ", exception);
	}
}

@end

