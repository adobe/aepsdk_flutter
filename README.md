# aepsdk-flutter

## About this project

This repository is a monorepo. It contains a collection of Adobe Experience Platform Mobile SDK Flutter plugins listed below. These plugins can be found in the [plugins](./plugins) directory.

## Installation

First, make sure that `Flutter` is [installed](https://docs.flutter.dev/get-started/install).

Now to install the package, run:

```
$ cd MyFlutterApp
$ flutter pub add flutter_{plugin_name}
```

This will add a line like this to your package's pubspec.yaml (and run an implicit flutter pub get):

```
dependencies:
  flutter_{plugin_name}: ^1.0.0
```

Now import the plugin in your Dart code as follows:

```
import 'package:flutter_{extension}/flutter_{plugin_name}.dart'
```

Install instructions for each respective plugin can be found in each plugin's readme: `/plugins/{plugin_name}/README.md`. Start by installing `flutter_aepcore` which is a dependency for all other extensions.

## Usage

### Initializing

Initializing the SDK should be done in native code (AppDelegate / SceneDelegate for iOS and Application class for Android). Documentation for initializing the SDK can be found [here](https://aep-sdks.gitbook.io/docs/getting-started/get-the-sdk#2-add-initialization-code).

As part of the initialization code, make sure that you set the SDK wrapper type to `Flutter` before you start the SDK.

Here is an example of initializing the SDK with AEPCore and AEPAssurance as done in the example app found in this repository:

### iOS

`AppDelegate.h`:

```objectivec
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
@import AEPCore;
@import AEPLifecycle;
@import AEPIdentity;
@import AEPServices;
@import AEPSignal;
@import AEPAssurance;

@interface AppDelegate : FlutterAppDelegate

@end

```

`AppDelegate.m`:

```objectivec
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    [self initSDK:application];

    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)initSDK:(UIApplication *) application {
    [AEPMobileCore setLogLevel:AEPLogLevelTrace];
    [AEPMobileCore setPrivacyStatus:AEPPrivacyStatusOptedIn];
    [AEPMobileCore setWrapperType:AEPWrapperTypeFlutter];
    
    const UIApplicationState appState = application.applicationState;
    
    NSArray *extensionsToRegister = @[AEPMobileIdentity.class, AEPMobileLifecycle.class, AEPMobileSignal.class, AEPMobileAssurance.class];
    
    [AEPMobileCore registerExtensions:extensionsToRegister completion:^{
        if (appState != UIApplicationStateBackground) {
            [AEPMobileCore lifecycleStart:nil];
        }
    }];
    
    [AEPMobileCore configureWithAppId:@"yourappidhere"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [AEPMobileCore lifecyclePause];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [AEPMobileCore lifecycleStart:nil];
}

@end
```

### Android

```java
package com.adobe.marketing.mobile.flutter.flutter_aepsdk_example;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.adobe.marketing.mobile.*;

import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {

    @Override
    public void onCreate() {
        super.onCreate();

        MobileCore.setApplication(this);
        MobileCore.setLogLevel(LoggingMode.VERBOSE);
        MobileCore.setWrapperType(WrapperType.FLUTTER);
        
        try {
            Identity.registerExtension();
            Lifecycle.registerExtension();
            Signal.registerExtension();
            Assurance.registerExtension();
            MobileCore.start(o -> MobileCore.configureWithAppID("yourAppId"));
        } catch (InvalidInitException e) {
            Log.e("MyApplication", String.format("Error while registering extensions %s", e.getLocalizedMessage()));
        }

        registerActivityLifecycleCallbacks(new ActivityLifecycleCallbacks() {
            @Override
            public void onActivityCreated(Activity activity, Bundle bundle) { /*no-op*/ }

            @Override
            public void onActivityStarted(Activity activity) { /*no-op*/ }

            @Override
            public void onActivityResumed(Activity activity) {
                MobileCore.setApplication(MyApplication.this);
                MobileCore.lifecycleStart(null);
            }

            @Override
            public void onActivityPaused(Activity activity) {
                MobileCore.lifecyclePause();
            }
```

## Tests

Run:

```
$ cd plugins/flutter_{plugin_name}/
$ flutter test
```

## Contributing

See [Contributing](CONTRIBUTING.md)

## License

See [License](LICENSE)
