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
  String _getExperienceCloudIdResult = '';
  String _getUrlVariablesResult = '';
  String _getIdentitiesResult = '';

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
    if (!mounted) {
      log('Failed to setState, widget is not mounted');
    }

    setState(() {
      _edgeIdentityVersion = edgeIdentityVersion;
    });
  }

  Future<void> getExperienceCloudId() async {
    String result = '';

    try {
      result = await Identity.getExperienceCloudId;
    } on PlatformException {
      log('Failed to get Experience Cloud id info');
    }

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
    }
    setState(() {
      _getExperienceCloudIdResult = result.toString();
    });
  }

  Future<void> getUrlVariables() async {
    String result = '';

    try {
      result = await Identity.getUrlVariables;
    } on PlatformException {
      log('Failed to get URL variable info');
    }

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
    }
    setState(() {
      _getUrlVariablesResult = result.toString();
    });
  }

  Future<void> getIdentities() async {
    IdentityMap result = new IdentityMap();

    try {
      result = await Identity.getIdentities;
    } on PlatformException {
      log('Failed to get identities');
    }

    if (!mounted) {
      log('Failed to setState, widget is not mounted');
    }
    setState(() {
      _getIdentitiesResult = json.encode(result.toString());
    });
  }

  Future<void> updateIdentities() async {
    IdentityItem item1 =
        new IdentityItem('id1', AuthenticatedState.AUTHENTICATED, false);
    IdentityItem item2_1 =
        new IdentityItem('id2_1', AuthenticatedState.LOGGED_OUT, true);
    IdentityItem item2_2 = new IdentityItem('id2_2');

    IdentityMap identityMap = new IdentityMap();
    identityMap.addItem(item1, 'namespace1');
    identityMap.addItem(item2_1, 'namespace2');
    identityMap.addItem(item2_2, 'namespace2');

    identityMap.removeItem(item2_1, 'namespace2');

    Identity.updateIdentities(identityMap);
  }

  Future<void> removeIdentity() async {
    IdentityItem item2_1 = new IdentityItem('id2_1');

    Identity.removeIdentities(item2_1, 'namespace2');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Edge Identity Screen')),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          getRichText(
              'AEPEdgeIdentity extension version: ', '$_edgeIdentityVersion\n'),
          ElevatedButton(
            child: Text('Identity.getExperienceCloudId()'),
            onPressed: () => getExperienceCloudId(),
          ),
          getRichText(
              'Experience Cloud Id: = ', '$_getExperienceCloudIdResult\n'),
          ElevatedButton(
            child: Text('Identity.getUrlVariable()'),
            onPressed: () => getUrlVariables(),
          ),
          getRichText('URL Variable: = ', '$_getUrlVariablesResult\n'),
          ElevatedButton(
            child: Text('Identity.getIdentites()'),
            onPressed: () => getIdentities(),
          ),
          getRichText('Identities: = ', '$_getIdentitiesResult\n'),
          ElevatedButton(
            child: Text('Identity.updateIdentites()'),
            onPressed: () => updateIdentities(),
          ),
          ElevatedButton(
            child: Text('Identity.removeIdentity()'),
            onPressed: () => removeIdentity(),
          ),
        ]),
      ));
}
