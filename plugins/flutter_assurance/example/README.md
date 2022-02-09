# flutter_assurance_example

Demonstrates how to use the flutter_assurance plugin.

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
flutter run ios
```
