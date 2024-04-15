/*
Copyright 2022 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepcore/flutter_aepcore_data.dart';
import 'package:flutter_aepcore/flutter_aeplifecycle.dart';
import 'package:flutter_aepcore/flutter_aepsignal.dart';
import 'util.dart';

class CorePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<CorePage> {
  String _coreVersion = 'Unknown';
  String _lifecycleVersion = 'Unknown';
  String _signalVersion = 'Unknown';
  String _sdkIdentities = "";
  String _privacyStatus = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String coreVersion, lifecycleVersion, signalVersion;

    coreVersion = await MobileCore.extensionVersion;
    lifecycleVersion = await Lifecycle.extensionVersion;
    signalVersion = await Signal.extensionVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _coreVersion = coreVersion;
      _lifecycleVersion = lifecycleVersion;
      _signalVersion = signalVersion;
    });
  }

  Future<void> getSdkIdentities() async {
    String result = "";

    try {
      result = await MobileCore.sdkIdentities;
    } on PlatformException {
      log("Failed to get sdk identities");
    }

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _sdkIdentities = result;
    });
  }

  Future<void> getPrivacyStatus() async {
    late PrivacyStatus result;

    try {
      result = await MobileCore.privacyStatus;
    } on PlatformException {
      log("Failed to get privacy status");
    }

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _privacyStatus = result.value;
    });
  }

  Future<void> setAdvertisingIdentifier() async {
    MobileCore.setAdvertisingIdentifier("ad-id");
  }

  Future<void> dispatchEvent() async {
    final Event event = Event({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await MobileCore.dispatchEvent(event);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
  }

  Future<void> dispatchEventWithResponseCallback() async {
    final Event event = Event({
      "eventName": "testEventName",
      "eventType": "testEventType",
      "eventSource": "testEventSource",
      "eventData": {"eventDataKey": "eventDataValue"}
    });
    try {
      await MobileCore.dispatchEventWithResponseCallback(event, 1500);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Core Screen")),
        body: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            getRichText('AEPCore extension version: ', '$_coreVersion\n'),
            getRichText(
                'AEPLifecycle extension version: ', '$_lifecycleVersion\n'),
            getRichText('AEPSignal extension version: ', '$_signalVersion\n'),
            getRichText('SDK Identities = ', '$_sdkIdentities\n'),
            getRichText('Privacy status = ', '$_privacyStatus\n'),
            ElevatedButton(
              child: Text("MobileCore.sdkIdentities"),
              onPressed: () => getSdkIdentities(),
            ),
            ElevatedButton(
              child: Text("MobileCore.resetIdentities"),
              onPressed: () => MobileCore.resetIdentities(),
            ),
            ElevatedButton(
              child: Text("MobileCore.privacyStatus"),
              onPressed: () => getPrivacyStatus(),
            ),
            ElevatedButton(
              child: Text("MobileCore.setLogLevel"),
              onPressed: () => MobileCore.setLogLevel(LogLevel.error),
            ),
            ElevatedButton(
              child: Text("MobileCore.setPrivacyStatus(...)"),
              onPressed: () =>
                  MobileCore.setPrivacyStatus(PrivacyStatus.opt_in),
            ),
            ElevatedButton(
              child: Text("MobileCore.updateConfiguration(...)"),
              onPressed: () => MobileCore.updateConfiguration({"key": "value"}),
            ),
            ElevatedButton(
              child: Text("MobileCore.clearUpdatedConfiguration"),
              onPressed: () => MobileCore.clearUpdatedConfiguration(),
            ),
            ElevatedButton(
              child: Text("MobileCore.setAppGroup"),
              onPressed: () => MobileCore.setAppGroup("testAppGroup"),
            ),
            ElevatedButton(
              child: Text("MobileCore.collectPii"),
              onPressed: () => MobileCore.collectPii({"testKey": "testValue"}),
            ),
            ElevatedButton(
              child: Text("MobileCore.setAdvertisingIdentifier(...)"),
              onPressed: () => setAdvertisingIdentifier(),
            ),
            ElevatedButton(
              child: Text("MobileCore.dispatchEvent(...)"),
              onPressed: () => dispatchEvent(),
            ),
            ElevatedButton(
              child: Text("MobileCore.dispatchEventWithResponseCallback(...)"),
              onPressed: () => dispatchEventWithResponseCallback(),
            ),
          ]),
        ),
      );
}
