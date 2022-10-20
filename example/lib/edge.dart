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
import 'package:flutter/material.dart';
import 'package:flutter_aepedge/flutter_aepedge_data.dart';
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

  Future<void> sendEvent([datasetId]) async {
    late List<EventHandle> result;
    Map<String, dynamic> xdmData = {"eventType": "SampleEventType"};
    Map<String, dynamic> data = {"free": "form", "data": "example"};

    final ExperienceEvent experienceEvent = ExperienceEvent(
        {"xdmData": xdmData, "data": null, "datasetIdentifier": null});

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

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Edge Screen")),
      body: Center(
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
          getRichText(
              'Response event handles: = ', '$_edgeEventHandleResponse\n'),
        ]),
      ));
}
