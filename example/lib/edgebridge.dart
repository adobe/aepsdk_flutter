/*
Copyright 2023 Adobe. All rights reserved.
This file is licensed to you under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License. You may obtain a copy
of the License at http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under
the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
OF ANY KIND, either express or implied. See the License for the specific language
governing permissions and limitations under the License.
*/

import 'dart:developer';
import 'util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepedgebridge/flutter_aepedgebridge.dart';

class EdgeBridgePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<EdgeBridgePage> {
  String _edgeBridgeVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String EdgeBridgeVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      EdgeBridgeVersion = await EdgeBridge.extensionVersion;
    } on PlatformException {
      log("Failed to get Edge Bridge extension versions");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _edgeBridgeVersion = EdgeBridgeVersion;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Edge Bridge Screen")),
        body: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            getRichText(
                'Edge Bridge extension version: ', '$_edgeBridgeVersion\n'),
            ElevatedButton(
              child: Text("MobileCore.trackAction"),
              onPressed: () => MobileCore.trackAction('purchase', 
              data: {
                "&&products": ";Running Shoes;1;69.95;event1|event2=55.99;eVar1=12345,;Running Socks;10;29.99;event2=10.95;eVar1=54321",
                "&&events": "event5,purchase",
                "myapp.promotion": "a0138"
              }),
            ),
            ElevatedButton(
              child: Text("MobileCore.trackState"),
              onPressed: () => MobileCore.trackState(
                 'products/189025/runningshoes/12345',
              data: {
                "&&products": ";Running Shoes;1;69.95;prodView|event2=55.99;eVar1=12345",
                "myapp.category": "189025",
                "myapp.promotion": "a0138"
              }),
            ),
          ]),
        ),
      );
}
