import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepassurance/flutter_aepassurance.dart';

class assurancePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<assurancePage> {
  String _assuranceVersion = 'Unknown';
  String _urlText = '';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String assuranceVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      assuranceVersion = await Assurance.extensionVersion;
    } on PlatformException {
      log("Failed to get Assurance extension versions");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _assuranceVersion = assuranceVersion;
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Assurance Screen")),
        body: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            Text('AEPAssurance version = $_assuranceVersion\n'),
            ElevatedButton(
              child: Text("MobileCore.trackState(...)"),
              onPressed: () =>
                  MobileCore.trackState("myState", data: {"key1": "value1"}),
            ),
            ElevatedButton(
              child: Text("MobileCore.trackAction(...)"),
              onPressed: () =>
                  MobileCore.trackAction("myAction", data: {"key1": "value1"}),
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
      );
}
