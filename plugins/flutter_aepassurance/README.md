# flutter_aepassurance

[![pub package](https://img.shields.io/pub/v/flutter_aepassurance.svg)](https://pub.dartlang.org/packages/flutter_aepassurance) ![Build](https://github.com/adobe/flutter_aepassurance/workflows/Dart%20Unit%20Tests%20+%20Android%20Build%20+%20iOS%20Build/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

`flutter_aepassurance` is a flutter plugin for the iOS and Android [AEPAssurance SDK](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-assurance) to allow for integration with Flutter applications. Functionality to enable the Assurance extension is provided entirely through Dart documented below.

## Installation

First, make sure that the [flutter_aepcore plugin is installed](./flutter_aepcore/README.md) as flutter_aepassurance depends on it. 

Install instructions for this package can be found [here](https://pub.dev/packages/flutter_aepassurance/install).

> Note: After you have installed the SDK, don't forget to run `pod install` in your `ios` directory to link the libraries to your Xcode project.

## Tests

Run:

```bash
flutter test
```

## Usage
### Assurance

For more detailed information on the Assurance APIs, visit the documentation [here](https://aep-sdks.gitbook.io/docs/using-mobile-extensions/adobe-experience-platform-assurance)

##### Registering the extension with AEPCore:

 > Note: It is required to initialize the SDK via native code inside your AppDelegate and MainApplication for iOS and Android respectively.

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
    
    NSArray *extensionsToRegister = @[AEPMobileIdentity.class, AEPMobileLifecycle.class, AEPMobileSignal.class, AEPAssurance.class];
    
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

##### Importing the SDK:
```dart
import 'package:flutter_aepassurance/flutter_aepassurance.dart';
```

##### Getting Assurance version:
 ```dart
String version = await Assurance.extensionVersion;
 ```

##### Starting a Assurance session:
 ```dart
Assurance.startSession(url);
 ```

## Contributing
See [CONTRIBUTING](CONTRIBUTING.md)

## License
See [LICENSE](LICENSE)
