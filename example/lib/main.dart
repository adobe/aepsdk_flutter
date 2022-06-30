import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepcore/flutter_aepcore_data.dart';
import 'package:flutter_aepcore/flutter_aepidentity.dart';
import 'package:flutter_aepcore/flutter_aeplifecycle.dart';
import 'package:flutter_aepcore/flutter_aepsignal.dart';
import 'package:flutter_aepassurance/flutter_aepassurance.dart';
import 'package:flutter_aepedge/flutter_aepedge.dart';
import 'package:flutter_aepedge/flutter_aepedge_data.dart';

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
  String _assuranceVersion = 'Unknown';
  String _edgeVersion = 'Unknown';
  String _appendToUrlResult = "";
  String _experienceCloudId = "";
  String _getUrlVariablesResult = "";
  String _getIdentifiersResult = "";
  String _sdkIdentities = "";
  String _privacyStatus = "";
  String _urlText = '';
  List<EventHandle> _edgeEventHandleResponse = List.empty();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String coreVersion,
        lifecycleVersion,
        signalVersion,
        identityVersion,
        assuranceVersion,
        edgeVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      coreVersion = await MobileCore.extensionVersion;
      identityVersion = await Identity.extensionVersion;
      lifecycleVersion = await Lifecycle.extensionVersion;
      signalVersion = await Signal.extensionVersion;
      assuranceVersion = await Assurance.extensionVersion;
      edgeVersion = await Edge.extensionVersion;
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
      _assuranceVersion = assuranceVersion;
      _edgeVersion = edgeVersion;
    });
  }

  Future<void> appendUrl() async {
    String result = "";

    try {
      result = await Identity.appendToUrl("www.myUrl.com");
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
      result = await Identity.experienceCloudId;
    } on PlatformException {
      log("Failed to get experienceCloudId");
    }

    if (!mounted) return;
    setState(() {
      _experienceCloudId = result;
    });
  }

  Future<void> syncIdentifiers() async {
    Identity.syncIdentifiers({
      "idType1": "idValue1",
      "idType2": "idValue2",
      "idType3": "idValue3",
    });
  }

  Future<void> syncIdentifiersWithAuthState() async {
    Identity.syncIdentifiersWithAuthState(
      {
        "idType1": "idValue1",
        "idType2": "idValue2",
        "idType3": "idValue3",
      },
      MobileVisitorAuthenticationState.authenticated,
    );
  }

  Future<void> syncIdentifier() async {
    Identity.syncIdentifier(
      "idType1",
      "idValue1",
      MobileVisitorAuthenticationState.authenticated,
    );
  }

  Future<void> getUrlVariables() async {
    String result = "";

    try {
      result = await Identity.urlVariables;
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
      result = await MobileCore.sdkIdentities;
    } on PlatformException {
      log("Failed to get sdk identities");
    }

    if (!mounted) return;
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

    if (!mounted) return;
    setState(() {
      _privacyStatus = result.value;
    });
  }

  Future<void> getIdentifiers() async {
    late List<Identifiable> result;

    try {
      result = await Identity.identifiers;
    } on PlatformException {
      log("Failed to get identifiers");
    }

    if (!mounted) return;
    setState(() {
      _getIdentifiersResult = result.toString();
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
      await MobileCore.dispatchEventWithResponseCallback(event);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }
  }

  Future<void> sendEvent([datasetId]) async {
    late List<EventHandle> result;
    Map<dynamic, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};

    final ExperienceEvent experienceevent = ExperienceEvent({
      "xdmData": xdmData,
      "data": data,
      "datasetIdentifier": datasetId,
    });
    try {
      result = await Edge.sendEvent(experienceevent);
    } on PlatformException catch (e) {
      log("Failed to dispatch event '${e.message}''");
    }

    if (!mounted) return;
    setState(() {
      _edgeEventHandleResponse = result;
    });
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
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Text('Core'),
              Text('Identity'),
              Text('Assurance'),
              Text('Edge')
            ],
          ),
          title: Text('Flutter AEP SDK'),
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
                  onPressed: () =>
                      MobileCore.updateConfiguration({"key": "value"}),
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
                  onPressed: () =>
                      MobileCore.collectPii({"testKey": "testValue"}),
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
                  child:
                      Text("MobileCore.dispatchEventWithResponseCallback(...)"),
                  onPressed: () => dispatchEventWithResponseCallback(),
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
                  child: Text("Identity.appendToUrl(...)"),
                  onPressed: () => appendUrl(),
                ),
                ElevatedButton(
                  child: Text("Identity.identifiers"),
                  onPressed: () => getIdentifiers(),
                ),
                ElevatedButton(
                  child: Text("Identity.experienceCloudId"),
                  onPressed: () => getExperienceCloudId(),
                ),
                ElevatedButton(
                  child: Text("Identity.syncIdentifier(...)"),
                  onPressed: () => syncIdentifier(),
                ),
                ElevatedButton(
                  child: Text("Identity.syncIdentifiersWithAuthState(...)"),
                  onPressed: () => syncIdentifiersWithAuthState(),
                ),
                ElevatedButton(
                  child: Text("Identity.urlVariables"),
                  onPressed: () => getUrlVariables(),
                ),
              ]),
            ),
            Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
                Text('AEPAssurance version = $_assuranceVersion\n'),
                ElevatedButton(
                  child: Text("MobileCore.trackState(...)"),
                  onPressed: () => MobileCore.trackState("myState",
                      data: {"key1": "value1"}),
                ),
                ElevatedButton(
                  child: Text("MobileCore.trackAction(...)"),
                  onPressed: () => MobileCore.trackAction("myAction",
                      data: {"key1": "value1"}),
                ),
                TextField(
                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                      hintText: 'Enter a assurance session url'),
                  onChanged: (text) {
                    _urlText = text;
                  },
                ),
                ElevatedButton(
                  child: Text("Assurance.startSession(...)"),
                  onPressed: () => Assurance.startSession(_urlText),
                ),
              ]),
            ),
            Center(
              child: ListView(shrinkWrap: true, children: <Widget>[
                getRichText('AEPEdge extension version: ', '$_edgeVersion\n'),
                ElevatedButton(
                  child: Text("Edge.sentEvent(...)"),
                  onPressed: () => sendEvent(),
                ),
                ElevatedButton(
                  child: Text("Edge.sentEvent to Dataset"),
                  onPressed: () => sendEvent('datasetIdExample'),
                ),
                getRichText('Response event handles: = ',
                    '$_edgeEventHandleResponse\n'),
              ]),
            )
          ],
        ),
      ),
    ));
  }
}
