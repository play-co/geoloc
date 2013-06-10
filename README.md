# Game Closure Devkit Plugin: Geolocation

## Usage

Include it in the `manifest.json` file under the "addons" section for your game:

~~~
"addons": [
	"geoloc"
],
~~~

At the top of your game's `src/Application.js`:

~~~
import plugins.geoloc.install;
~~~

Now you can use the normal HTML5 `navigator.geolocation.getCurrentPosition` API:

~~~
navigator.geolocation.getCurrentPosition(bind(this, function(pos) {
	var lat = pos.coords.latitude;
	var lng = pos.coords.longitude;
}), bind(this, function(err) {
	logger.log("FAIL:", err.code);
}));
~~~

## Platform-specific notes

### Browsers

Does not seem to work for file:// paths, so you will want to test it in the `basil serve` mode to see it working.

On Chrome you will want to add the localhost:9200 "domain" to the geolocation permitted groups.  There will be a new icon on the right of the navigator bar you can interact with to add it.

On other browsers it will work the same as the normal HTML5 geolocation API.

### iOS

The GPS subsystem will be enabled by a popup that the user must accept.

Requests until they accept the popup will fail.

### Android

The GPS subsystem is often manually turned off to save battery, so the user will be prompted to switch to the Settings app to enable GPS for use in your app.  If they tap the OK button it will take them right to that settings pane.  Pressing the back button will take them directly back to your game.

Requests until they enable GPS will fail.

After the first GPS request it takes roughly 30 seconds for the GPS to warm up.  You will start getting GPS callbacks after the GPS warmup completes on this platform, so it may be a good idea to display a warning.

When testing your app, be sure to try disabling GPS, cancelling the dialog, and other usage patterns to make sure that the user has a seamless experience in all cases.
