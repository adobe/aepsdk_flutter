# Creating your own AEP Extension Flutter Wrapper 

## Initial Setup

1. Make sure you have [flutter installed](https://docs.flutter.dev/get-started/install/macos) on your machine.

2. Fork [this repository](https://github.com/adobe/aepsdk_flutter)

3. Create a branch with your plugin name off of the main branch e.g: `edge`. Make sure all of the upcoming steps / work is done on your newly created plugin branch. 

4. Navigate to the plugin directory 
`cd aepsdk_flutter/plugins/`

5. Follow the steps [outlined here](https://docs.flutter.dev/development/packages-and-plugins/developing-packages#step-1-create-the-package-1) to create a template plugin, replace "hello" with your plugin name preceded by `flutter_aep` e.g: `flutter_aepedge`.

## Add Dependencies

1. iOS: Add the dependency for the AEP extension you are writing a wrapper for in your podspec file found under `{yourPluginName}/ios/{flutter_wrapper_name}.podspec`. Follow the pattern shown in the other podspec files found in any of the other [respective plugin directories.](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepassurance/ios/flutter_aepassurance.podspec)

2. Android: Add the depdendency for the AEP extension you are writing a wrapper for in your build.gradle file found under `{yourPluginName}/android/build.gradle`. Follow the pattern shown in the other build.gradle files found in any of the other [respective plugin directories.](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepassurance/android/build.gradle)

3. Flutter: Add the dependency for the AEP extension you are writing a wrapper for in your pubspec.yml. Follow the pattern shown in the other pubspec files found in any of the other [respective plugin directories](https://github.com/adobe/aepsdk_flutter/blob/main/plugins/flutter_aepassurance/pubspec.yaml)

## Write Native Code

### iOS

1. In order to write native code, it will be easier to use the workspace generated under the `{yourPluginName}/example/ios/Runner.xcworkspace`. This will open the Workspace in Xcode and allow you to have code completion and the other benefits of the IDE.

2. Navigate to the `{yourPluginName}Plugin.m` and import the Extension you are writing a wrapper for plus any additional dependencies. e.g: `@import AEPEdge;`

3. Implement your bridge. The two main functions to implement are the `(void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar` and the `(void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result`. Implementations will look different for everyone, but make sure that you implement these two functions to properly register your plugin with the registrar, and handle the method calls.

### Android

In order to write native code, it will be easier to use your preferred Android development IDE. Android Studio is recommended as it has integrations with Gradle which will simplify things. 

1. Open the generated `android` directory in your IDE

2. Nativate to the `{yourPluginName}Plugin.java` and import the Extension you are writing a wrapper for plus any additional dependencies. e.g: `import com.adobe.marketing.mobile.Edge;`

3. Implement your bridge. The 3 main functions to implement are: `public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding)`, `public void onAttachedToEngine(@NonNull final FlutterPluginBinding binding)`, and `public void onMethodCall(MethodCall call, Result result)`. Implementations will look different for everyone, but make sure that you implement these functions to properly attach/detach your plugin to the engine, and handle the method calls. 

## Write Dart Code

1. Implement your dart code in `{yourPluginName}.dart` file. You will want to implement the public APIs here and make sure the signature matches as closely as possible to the native API. You will simply invoke the native method using the `_channel.invokeMethod` API. 

2. Write Dart tests in your `test/` directory. The dart tests should simply make sure that the correct values are being passed to and from the bridge, and that the correct methods are being invoked.



## Update Sample App (optional)

If you want this plugin to be included in the sample app, then you need to do the following:

1. Navigate to the monorepo's `aepsdk_flutter/example/pubspec.yml` file, and include your plugin as a path dependency (This is for active development. Once your plugin is published, you can change it to point to the published plugin instead.). To include your plugin via path add the following to the `pubspec.yml` under the `dev_dependencies:` section: 

```
...

dev_dependencies:

your_plugin_name:
    path: ../plugins/your_plugin_name

...

```
2. Next you will update the example app dart code under `example/lib/main.dart`. First, import your package at the top:
`import 'package:flutter_{yourPluginName}/flutter_{yourPluginName}.dart'`. 

3. How the example app will use your plugin is up to you, but simply add integrations with your public APIs to the UI.

4. Next, you will update the example app native code. 

    a. For iOS, update the AppDelegate to register your extension. If your extension requires native code support to work, add it now.

    b. For Android, update the MyApplication.java to register the new extension. If your extension requires native code support to work, add it now.

5. To make sure the ios project is configured correctly, run "flutter pub get" from the "example" directory. Then run a "pod install" from the ios directory. Now open the Runner.xcworkspace and make sure it builds correctly.

6. To make sure the Android project is configured correctly, open the android directory in Android Studio and make sure the automated gradle scripts work properly. 

## Testing:

1. Now, you are ready to test your plugin. Make sure that you have run `flutter pub get` from the example directory, and then a `pod install` from the ios directory.

2. Set up a launch property and add the app id to the native code for both android and ios. 

3. Set up an Assurance session. Note that for android the host url is: "aepsdkflutter://adobe" and for iOS it is: "aepsdkflutter://host"

4. Testing Android can be done via Android Studio. Simply open the "example/android/" directory in Android Studio and run the app. This works since Flutter is integrated with Android Studio. 

5. Testing iOS is done by running `flutter pub get` from the example directory, then `pod install` from the example/ios directory. Then, make sure that you have an xcode simulator running (only an ios simulator, close out any android ones). Now from the command line run `flutter run`. 

6. Once the Android/iOS flutter app is running, simply connect your assurance session using the assurance field and begin testing.

7. You can now run the unit tests as well by navigating to your plugin's directory and running `flutter test` from the command line which will run the tests found in the `tests` directory.

## Documenting:

1. Make sure to add your plugin under the "aepsdk_flutter/README.md#about-this-project" section. You can add the url before it is actually published and it will work once its published. Simply use the same url as the existing plugins with the plugin name replaced. E.g: https://pub.dartlang.org/packages/flutter_{your_plugin_name}.

2. Update the migration doc found under "/docs/migration.md" with migration support for your plugin.
3. Make sure you have a README.md for your plugin. Follow the same outline as the existing plugins. NOTE: Make sure that all of the urls used in your readme are absolute URLs. Relative urls will not work once your plugin is published to pub.dev and the README is used as the homepage for your plugin.

4. Make sure you have copied over the license into your plugin directory, and add a CHANGELOG.md as well. These are required per plugin by Flutter.

## Submit Pull Request:

You are now ready to submit a final pull request for approval. Someone from the Adobe team will review your pull request. Once it is approved, we will take care of publishing the plugin using our Pub.dev Adobe Verified Publisher. 


