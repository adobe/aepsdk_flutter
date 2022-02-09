import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_assurance/flutter_assurance.dart';
import 'package:flutter_acpcore/flutter_acpcore.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _platformVersion = 'Unknown';
  String _url_text = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? assuranceVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      assuranceVersion = await FlutterAssurance.extensionVersion;
    } on PlatformException {
      log("Failed to get extension versions");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = assuranceVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            Text('AEPAssurance version = $_platformVersion\n'),
            ElevatedButton(
              child: Text("ACPCore.trackState(...)"),
              onPressed: () => FlutterACPCore.trackState("myState",
                  data: {"key1": "value1"}),
            ),
            ElevatedButton(
              child: Text("ACPCore.trackAction(...)"),
              onPressed: () => FlutterACPCore.trackAction("myAction",
                  data: {"key1": "value1"}),
            ),
            TextField(
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.teal)),
                  hintText: 'Enter a assurance session url'),
              onChanged: (text) {
                _url_text = text;
              },
            ),
            ElevatedButton(
              child: Text("AEPAssurance.startSession(...)"),
              onPressed: () => FlutterAssurance.startSession(_url_text),
            ),
          ]),
        ),
      ),
    );
  }
}