# flutter_aepsdk_example

Demonstrates how to use the flutter_aepsdk plugins.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


## How to run the example app:

### Add your App Id:
In `ios/Runner/AppDelegate.m`, find the call to `configureWithAppId` and add your app id.

In `android/**/MyApplication.java`, find the call to `configureWithAppId` and add your app id.

#### Run instructions for Android:

Ensure you have an Android emulator/device connected.

```
cd example
flutter pub get
flutter run
```

#### Run instructions for iOS:

Ensure you have an iOS simulator/device connected.

```
cd example
flutter pub get
cd ios && pod install && cd ../
flutter run
```

## How to use Assurance

If this is your first time using Assurance, make sure you get familiar with how to get up and running by reading the documentation [here](https://developer.adobe.com/client-sdks/documentation/platform-assurance/)

The base url for the iOS app is `aepsdkflutter://host` and for Android it is `aepsdkflutter://adobe`. Once the example app is running, and you have entered the base url for the Assurance session on the web, navigate to the Assurance tab in the app, and paste the link received from the Griffon web portal. Now hit `start session` to begin your Assurance session.
