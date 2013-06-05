var onSuccess = [];
var onFail = [];

NATIVE.events.registerHandler('geoloc', function(evt) {
	if (evt.failed) {
		// Create HTML5-like error object
		var err = {
			PERMISSION_DENIED: "Permission Denied",
			POSITION_UNAVAILABLE: "Position Unavailable",
			TIMEOUT: "Timeout",
			UNKNOWN_ERROR: "Unknown Error",

			code: "Position Unavailable"
		};

		// Invoke all the callbacks
		for (var ii = 0; ii < onSuccess.length; ++ii) {
			onFail[ii](err);
		}
	} else {
		// Create HTML5-like position object
		var pos = {
			coords: {
				latitude: evt.latitude,
				longitude: evt.longitude
			}
		};

		// Invoke all the callbacks
		for (var ii = 0; ii < onSuccess.length; ++ii) {
			onSuccess[ii](pos);
		}
	}

	// Clear callbacks array
	onSuccess.length = 0;
	onFail.length = 0;
});

// The navigator global already exists, but the geolocation property does not.
// So add it:

GLOBAL.navigator.geolocation = {
	getCurrentPosition: function(cbSuccess, cbFail) {
		// Post a new request
		NATIVE.plugins.sendEvent("GeolocPlugin", "onRequest", "");

		// Insert callbacks into waiting lists
		if (typeof(cbSuccess) == "function") {
			onSuccess.push(cbSuccess);
		}
		if (typeof(cbFail) == "function") {
			onFail.push(cbFail);
		}
	}
}

