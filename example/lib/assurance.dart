import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepassurance/flutter_aepassurance.dart';

class AssurancePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<AssurancePage> {
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Assurance Screen")),
        body: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            Text('AEPAssurance version = $_assuranceVersion\n'),
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
