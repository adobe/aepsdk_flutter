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

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepedgeidentity/flutter_aepedgeidentity_data.dart';
import 'package:flutter_aepedgeidentity/flutter_aepedgeidentity.dart';
import 'util.dart';

class EdgeIdentityPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<EdgeIdentityPage> {
  String _edgeIdentityVersion = 'Unknown';
  String _getExperienceCloudIdResult = "";
  String _getUrlVariablesResult = "";
  String _getIdentitiesResult = "";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String edgeIdentityVersion;

    edgeIdentityVersion = await Identity.extensionVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _edgeIdentityVersion = edgeIdentityVersion;
    });
  }

  Future<void> getExperienceCloudId() async {
    String result = "";

    try {
      result = await Identity.getExperienceCloudId;
    } on PlatformException {
      log("Failed to get Experience Cloud id info");
    }

    if (!mounted) return;
    setState(() {
      _getExperienceCloudIdResult = result.toString();
    });
  }

  Future<void> getUrlVariables() async {
    String result = "";

    try {
      result = await Identity.getUrlVariables;
    } on PlatformException {
      log("Failed to get URL variable info");
    }

    if (!mounted) return;
    setState(() {
      _getUrlVariablesResult = result.toString();
    });
  }

  Future<void> getIdentities() async {
    IdentityMap result = new IdentityMap();
    bool test1 = result.isEmpty();
    print("test1 is: $test1");

    try {
      result = await Identity.getIdentities;
    } on PlatformException {
      log("Failed to get identities");
    }

    if (!mounted) return;
    setState(() {
      _getIdentitiesResult = json.encode(result.toString());
      bool test2 = result.isEmpty();
      print("test2 is: $test2");
      print("loghere $result");
    });
  }

  Future<void> updateIdentities() async {
    //String result = "";
    String namespace1 = 'namespace1';
    String id = "id";

    IdentityItem item1 =
        new IdentityItem(id, AuthenticatedState.AUTHENTICATED, true);
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.AUTHENTICATED, false);
    IdentityItem item3 =
        new IdentityItem('id3', AuthenticatedState.AUTHENTICATED, false);

    IdentityMap identityMap = new IdentityMap();
    identityMap.addItem(item1, namespace1);
    identityMap.addItem(item2, "namespace2");
    //identityMap.addItem(item3, "namespace3");

    bool test1 = identityMap.isEmpty();

    Identity.updateIdentities(identityMap);

    var testnamespace = identityMap.getNamespaces();
    print("loghere $testnamespace");
    var testIdentityNamespace =
        identityMap.getIdentityItemsForNamespace((namespace1));
    print("loghere $testIdentityNamespace");
  }

  Future<void> removeIdentity() async {
    String namespace1 = 'namespace1';
    String namespace2 = 'namespace2';
    //String namespace2 = 'namespace2FromApp2';
    String id = "id";

    IdentityItem item1 =
        new IdentityItem(id, AuthenticatedState.AUTHENTICATED, true);
    IdentityItem item2 =
        new IdentityItem('id2', AuthenticatedState.AMBIGOUS, false);

    IdentityMap identityMap = new IdentityMap();

    bool test2 = identityMap.isEmpty();
    //identityMap.removeItem(item2, namespace1);
    //identityMap.removeItem(item1, namespace1);
    Identity.removeIdentities(item1, namespace1);
    // Identity.removeIdentities(item2, namespace2);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Edge Identity Screen")),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          getRichText(
              'AEPEdgeIdentity extension version: ', '$_edgeIdentityVersion\n'),
          ElevatedButton(
            child: Text("Identity.getExperienceCloudId()"),
            onPressed: () => getExperienceCloudId(),
          ),
          getRichText(
              'Experience Cloud Id: = ', '$_getExperienceCloudIdResult\n'),
          ElevatedButton(
            child: Text("Identity.getUrlVariable()"),
            onPressed: () => getUrlVariables(),
          ),
          getRichText('URL Variable: = ', '$_getUrlVariablesResult\n'),
          ElevatedButton(
            child: Text("Identity.getIdentites()"),
            onPressed: () => getIdentities(),
          ),
          getRichText('Identities: = ', '$_getIdentitiesResult\n'),
          ElevatedButton(
            child: Text("Identity.updateIdentites()"),
            onPressed: () => updateIdentities(),
          ),
          ElevatedButton(
            child: Text("Identity.removeIdentity()"),
            onPressed: () => removeIdentity(),
          ),
        ]),
      ));
}
