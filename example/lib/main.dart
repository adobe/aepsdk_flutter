import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepcore/flutter_aepcore_data.dart';
import 'package:flutter_aepcore/flutter_aepidentity.dart';
import 'package:flutter_aepcore/flutter_aeplifecycle.dart';
import 'package:flutter_aepcore/flutter_aepsignal.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _coreVersion = 'Unknown';
  String _identityVersion = 'Unknown';
  String _lifecycleVersion = 'Unknown';
  String _signalVersion = 'Unknown';
  String _appendToUrlResult = "";
  String _experienceCloudId = "";
  String _getUrlVariablesResult = "";
  String _getIdentifiersResult = "";
  String _sdkIdentities = "";
  String _privacyStatus = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String coreVersion, lifecycleVersion, signalVersion, identityVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      coreVersion = await FlutterAEPCore.extensionVersion;
      identityVersion = await FlutterAEPIdentity.extensionVersion;
      lifecycleVersion = await FlutterAEPLifecycle.extensionVersion;
      signalVersion = await FlutterAEPSignal.extensionVersion;
    } on PlatformException {
      log("Failed to get extension versions");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _coreVersion = coreVersion;
      _identityVersion = identityVersion;
      _lifecycleVersion = lifecycleVersion;
      _signalVersion = signalVersion;
    });
  }

  Future<void> appendUrl() async {
    String result = "";

    try {
      result = await FlutterAEPIdentity.appendToUrl("www.myUrl.com");
    } on PlatformException {
      log("Failed to append URL");
    }

    if (!mounted) return;
    setState(() {
      _appendToUrlResult = result;
    });
  }

  Future<void> getExperienceCloudId() async {
    String result = "";

    try {
      result = await FlutterAEPIdentity.experienceCloudId;
    } on PlatformException {
      log("Failed to get experienceCloudId");
    }

    if (!mounted) return;
    setState(() {
      _experienceCloudId = result;
    });
  }

  Future<void> syncIdentifiers() async {
    FlutterAEPIdentity.syncIdentifiers({
      "idType1": "idValue1",
      "idType2": "idValue2",
      "idType3": "idValue3",
    });
  }

  Future<void> syncIdentifiersWithAuthState() async {
    FlutterAEPIdentity.syncIdentifiersWithAuthState(
      {
        "idType1": "idValue1",
        "idType2": "idValue2",
        "idType3": "idValue3",
      },
      AEPMobileVisitorAuthState.authenticated,
    );
  }

  Future<void> syncIdentifier() async {
    FlutterAEPIdentity.syncIdentifier(
      "idType1",
      "idValue1",
      AEPMobileVisitorAuthState.authenticated,
    );
  }

  Future<void> getUrlVariables() async {
    String result = "";

    try {
      result = await FlutterAEPIdentity.urlVariables;
    } on PlatformException {
      log("Failed to get url variables");
    }

    if (!mounted) return;
    setState(() {
      _getUrlVariablesResult = result;
    });
  }

  Future<void> getSdkIdentities() async {
    String result = "";

    try {
      result = await FlutterAEPCore.sdkIdentities;
    } on PlatformException {
      log("Failed to get sdk identities");
    }

    if (!mounted) return;
    setState(() {
      _sdkIdentities = result;
    });
  }

  Future<void> getPrivacyStatus() async {
    late AEPPrivacyStatus result;

    try {
      result = await FlutterAEPCore.privacyStatus;
    } on PlatformException {
      log("Failed to get privacy status");
    }

    if (!mounted) return;
    setState(() {
      _privacyStatus = result.value;
    });
  }

  Future<void> getIdentifiers() async {
    late List<AEPMobileVisitorId> result;

    try {
      result = await FlutterAEPIdentity.identifiers;
    } on PlatformException {
      log("Failed to get identifiers");
    }

    if (!mounted) return;
    setState(() {
      _getIdentifiersResult = result.toString();
    });
  }

  Future<void> setAdvertisingIdentifier() async {
    FlutterAEPCore.setAdvertisingIdentifier("ad-id");
  }

  Future<void> dispatchEvent() async {
    final AEPEvent event = AEPEvent({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await FlutterAEPCore.dispatchEvent(event);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
  }

  Future<void> dispatchEventWithResponseCallback() async {
    final AEPEvent event = AEPEvent({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await FlutterAEPCore.dispatchEventWithResponseCallback(event);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
  }

  Future<void> dispatchResponseEvent() async {
    final AEPEvent responseEvent = AEPEvent({
      "eventName": "testresponseEvent",
      "eventType": "testresponseEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    final AEPEvent requestEvent = AEPEvent({
      "eventName": "testrequestEvent",
      "eventType": "testrequestEvent",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await FlutterAEPCore.dispatchResponseEvent(responseEvent, requestEvent);
    } on PlatformException catch (e) {
      log("Failed to dispatch events '${e.message}''");
    }
  }

  // UTIL
  RichText getRichText(String label, String value) {
    return new RichText(
      text: new TextSpan(
        // Note: Styles for TextSpans must be explicitly defined.
        // Child text spans will inherit styles from parent
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.black,
        ),
        children: <TextSpan>[
          new TextSpan(
              text: label, style: new TextStyle(fontWeight: FontWeight.bold)),
          new TextSpan(text: value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text('Core'),
              Text('Identity'),
            ],
          ),
          title: Text('Flutter AEPCore'),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
                getRichText('AEPCore extension version: ', '$_coreVersion\n'),
                getRichText(
                    'AEPLifecycle extension version: ', '$_lifecycleVersion\n'),
                getRichText(
                    'AEPSignal extension version: ', '$_signalVersion\n'),
                getRichText('SDK Identities = ', '$_sdkIdentities\n'),
                getRichText('Privacy status = ', '$_privacyStatus\n'),
                ElevatedButton(
                  child: Text("FlutterAEPCore.sdkIdentities"),
                  onPressed: () => getSdkIdentities(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPCore.privacyStatus"),
                  onPressed: () => getPrivacyStatus(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPCore.setLogLevel"),
                  onPressed: () =>
                      FlutterAEPCore.setLogLevel(AEPLogLevel.error),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPCore.setPrivacyStatus(...)"),
                  onPressed: () =>
                      FlutterAEPCore.setPrivacyStatus(AEPPrivacyStatus.opt_in),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPCore.updateConfiguration(...)"),
                  onPressed: () =>
                      FlutterAEPCore.updateConfiguration({"key": "value"}),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPCore.setAdvertisingIdentifier(...)"),
                  onPressed: () => setAdvertisingIdentifier(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPCore.dispatchEvent(...)"),
                  onPressed: () => dispatchEvent(),
                ),
                ElevatedButton(
                  child: Text(
                      "FlutterAEPCore.dispatchEventWithResponseCallback(...)"),
                  onPressed: () => dispatchEventWithResponseCallback(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPCore.dispatchResponseEvent(...)"),
                  onPressed: () => dispatchResponseEvent(),
                ),
              ]),
            ),
            Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
                getRichText(
                    'AEPIdentity extension version: ', '$_identityVersion\n'),
                getRichText('Append to URL result = ', '$_appendToUrlResult\n'),
                getRichText('Experience Cloud ID = ', '$_experienceCloudId\n'),
                getRichText(
                    'Get URL variables result = ', '$_getUrlVariablesResult\n'),
                getRichText('Identifiers = ', '$_getIdentifiersResult\n'),
                ElevatedButton(
                  child: Text("FlutterAEPIdentity.appendToUrl(...)"),
                  onPressed: () => appendUrl(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPIdentity.identifiers"),
                  onPressed: () => getIdentifiers(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPIdentity.experienceCloudId"),
                  onPressed: () => getExperienceCloudId(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPIdentity.syncIdentifier(...)"),
                  onPressed: () => syncIdentifier(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPIdentity.syncIdentifiers(...)"),
                  onPressed: () => syncIdentifiers(),
                ),
                ElevatedButton(
                  child: Text(
                      "FlutterAEPIdentity.syncIdentifiersWithAuthState(...)"),
                  onPressed: () => syncIdentifiersWithAuthState(),
                ),
                ElevatedButton(
                  child: Text("FlutterAEPIdentity.urlVariables"),
                  onPressed: () => getUrlVariables(),
                ),
              ]),
            ),
          ],
        ),
      ),
    ));
  }
}
