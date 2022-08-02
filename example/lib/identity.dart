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
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore_data.dart';
import 'package:flutter_aepcore/flutter_aepidentity.dart';
import 'util.dart';

class IdentityPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<IdentityPage> {
  String _identityVersion = 'Unknown';
  String _appendToUrlResult = "";
  String _experienceCloudId = "";
  String _getUrlVariablesResult = "";
  String _getIdentifiersResult = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String identityVersion;

    identityVersion = await Identity.extensionVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _identityVersion = identityVersion;
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

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Identity Screen")),
        body: Center(
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
      );
}
