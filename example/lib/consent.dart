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
import 'util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepedgeconsent/flutter_aepedgeconsent.dart';

class ConsentPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<ConsentPage> {
  String _consentVersion = 'Unknown';
  String _getConsentsResult = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String consentVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      consentVersion = await Consent.extensionVersion;
    } on PlatformException {
      log("Failed to get extension versions");
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _consentVersion = consentVersion;
    });
  }

  Future<void> getConsent() async {
    Map<String, dynamic> result = {};

    try {
      result = await Consent.consents;
    } on PlatformException {
      log("Failed to get consent info");
    }

    if (!mounted) return;
    setState(() {
      _getConsentsResult = result.toString();
    });
  }

  Future<void> setDefaultConsent(bool allowed) async {
    Map<String, Object> collectConsents = allowed
        ? {
            "collect": {"val": "y"}
          }
        : {
            "collect": {"val": "n"}
          };
    Map<String, Object> currentConsents = {"consents": collectConsents};
    Map<String, Object> defaultConsents = {"consents.default": currentConsents};

    MobileCore.updateConfiguration(defaultConsents);
  }

  Future<void> updateConsent(bool allowed) async {
    Map<String, dynamic> collectConsents = allowed
        ? {
            "collect": {"val": "y"}
          }
        : {
            "collect": {"val": "n"}
          };
    Map<String, dynamic> currentConsents = {"consents": collectConsents};

    Consent.update(currentConsents);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Consent Screen")),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          getRichText('AEPConsent extension version: ', '$_consentVersion\n'),
          getRichText('Current Consent = ', '$_getConsentsResult\n'),
          ElevatedButton(
            child: Text("Get Consents"),
            onPressed: () => getConsent(),
          ),
          ElevatedButton(
            child: Text("Set Default Consent - Yes"),
            onPressed: () => setDefaultConsent(true),
          ),
          ElevatedButton(
            child: Text("Set Collect Consent - Yes"),
            onPressed: () => updateConsent(true),
          ),
          ElevatedButton(
            child: Text("Set Collect Consent - No"),
            onPressed: () => updateConsent(false),
          ),
        ]),
      ));
}
