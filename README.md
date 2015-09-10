# GoogleAnalyticsHelper
A simple wrapper for the official Google Analytics lib. Write less code.

### Setup
The supported installation method is Cocoapods.

```ruby
pod 'GoogleAnalyticsHelper'
```

After the pod is installed setup the tracker the first thing when the app starts:

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Initialize with Google Analytics tracking id.
    [GAH setupWithTrackedId:@"<#Tracking ID#>"];

    //Or, you can set it up by dragging your GoogleService-Info.plist to your Xcode project and add it to all targets.
    [GAH setupTracker];

    ...The rest of your customizations...
}
```

## Configuration


```objc
[GAH setTracksUncaughtExceptions:YES];
[GAH setSyncInterval:60];
[GAH setOptOut:YES];
[GAH setAnonymizeIp:YES];
[GAH setLogLevel:kGAHLogLevelVerbose];

[GAH setTrackBuildInfo:YES];
[GAH setTrackDeviceInfo:YES];
```

## Contribution

Development and issues are tracked here on Github. Pull requests are welcomed.

### Contributors

* [Magnus Ottosson](https://github.com/permagnus)

## Credits
Inspired and based on [**BNEasyGoogleAnalyticsr**](https://github.com/brandnetworks/BNEasyGoogleAnalytics)


## License

GoogleAnalyticsHelper is available under the [MIT license](https://raw.githubusercontent.com/permagnus/GoogleAnalyticsHelper/master/LICENSE).