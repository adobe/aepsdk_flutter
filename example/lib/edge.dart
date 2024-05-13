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

import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aepedge/flutter_aepedge.dart';
import 'util.dart';

class EdgePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<EdgePage> {
  String _edgeVersion = 'Unknown';

  List<EventHandle> _edgeEventHandleResponse = List.empty();
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  String? _edgeLocationHint = 'null';

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String edgeVersion;

    edgeVersion = await Edge.extensionVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeVersion = edgeVersion;
    });
  }

  //Using Dictionaries method
  Future<void> sendEventWithDictionaryDatasetId([datasetId]) async {
    late List<EventHandle> result;
    Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};

    final ExperienceEvent experienceEvent = ExperienceEvent(
        {"xdmData": xdmData, "data": data, "datasetIdentifier": datasetId});

    result = await Edge.sendEvent(experienceEvent);

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeEventHandleResponse = result;
      print("result info " + result.toString());
    });
  }

  Future<void> sendEventWithDictionaryDatastreamIdOverride() async {
    late List<EventHandle> result;
    Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};

    final ExperienceEvent experienceEvent = ExperienceEvent(
      {
        "xdmData": xdmData,
        "data": data,
        "datastreamIdOverride": "sampleDatastreamId",
      });

    result = await Edge.sendEvent(experienceEvent);

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeEventHandleResponse = result;
      print("result info " + result.toString());
    });
  }

  Future<void> sendEventWithDictionaryDatastreamConfigOverride() async {
    late List<EventHandle> result;
    Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};
    Map<String, dynamic> configOverrides = {
      "com_adobe_experience_platform": {
        "datasets": {
          "event": {
            "datasetId": "sampleDatasetId"
          }
        }
      }
    };

    final ExperienceEvent experienceEvent = ExperienceEvent(
      {
        "xdmData": xdmData,
        "data": data,
        "datastreamConfigOverride": configOverrides,
      });

    result = await Edge.sendEvent(experienceEvent);

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeEventHandleResponse = result;
      print("result info " + result.toString());
    });
  }

  //Using Constructors
  Future<void> sendEventWithConstructorDatasetId([datasetId]) async {
    late List<EventHandle> result;
    Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};

    final ExperienceEvent experienceEvent = ExperienceEvent.createEvent(xdmData, data, datasetId);

    result = await Edge.sendEvent(experienceEvent);

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeEventHandleResponse = result;
      print("result info " + result.toString());
    });
  }

  Future<void> sendEventWithConstructorDatastreamIdOverride() async {
    late List<EventHandle> result;
    Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};

    final ExperienceEvent experienceEvent = ExperienceEvent.createEventWithOverrides(xdmData, data, "sampleDatastreamId");
   
    result = await Edge.sendEvent(experienceEvent);

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeEventHandleResponse = result;
      print("result info " + result.toString());
    });
  }

  Future<void> sendEventWithConstructorDatastreamConfigOverride() async {
    late List<EventHandle> result;
    Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};
    //To override eventDataset using datastream config overrides
    Map<String, dynamic> configOverrides = {
      "com_adobe_experience_platform": {
        "datasets": {
          "event": {
            "datasetId": "sampleDatasetId"
          }
        }
      }
    };

    final ExperienceEvent experienceEvent = ExperienceEvent.createEventWithOverrides(xdmData, data, null, configOverrides);

    result = await Edge.sendEvent(experienceEvent);

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeEventHandleResponse = result;
      print("result info " + result.toString());
    });
  }

  Future<void> getLocationHint() async {
    String? result = null;

    try {
      result = await Edge.locationHint;
    } on PlatformException {
      log("Failed to get location hint");
    }

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeLocationHint = result;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Edge Screen")),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          getRichText('AEPEdge extension version: ', '$_edgeVersion\n'), 
          ElevatedButton(
            child: Text("sendEventWithDictionary"),
            onPressed: () => sendEventWithDictionaryDatasetId(),
          ),
          ElevatedButton(
            child: Text("sendEventWithDictionary to Dataset"),
            onPressed: () => sendEventWithDictionaryDatasetId('datasetId_example'),
          ),
          ElevatedButton(
            child: Text("sendEventWithDictionary datastreamIdOverride"),
            onPressed: () => sendEventWithDictionaryDatastreamIdOverride(),
          ),
          ElevatedButton(
            child: Text("sendEventWithDictionary datastreamConfigOverride"),
            onPressed: () => sendEventWithDictionaryDatastreamConfigOverride(),
          ),
           ElevatedButton(
            child: Text("sendEventWithConstructor to Dataset"),
            onPressed: () => sendEventWithConstructorDatasetId('datasetId_example'),
          ),
          ElevatedButton(
            child: Text("sendEventWithConstructor datastreamIdOverride"),
            onPressed: () => sendEventWithConstructorDatastreamIdOverride(),
          ),
          ElevatedButton(
            child: Text("sendEventWithConstructor datastreamConfigOverride"),
            onPressed: () => sendEventWithConstructorDatastreamConfigOverride(),
          ),
          getRichText(
              'Response event handles: = ', '$_edgeEventHandleResponse\n'),
          ElevatedButton(
            child: Text("setLocationHint(empty)"),
            onPressed: () => Edge.setLocationHint(""),
          ),
          ElevatedButton(
            child: Text("setLocationHint(va6)"),
            onPressed: () => Edge.setLocationHint("va6"),
          ),
          ElevatedButton(
            child: Text("getLocationHint"),
            onPressed: () => getLocationHint(),
          ),
          getRichText('Get Location hint: = ', '$_edgeLocationHint\n'),
        ]),
      ));
}
