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

import 'package:flutter/material.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'messaging.dart';
import 'core.dart';
import 'assurance.dart';
import 'edge.dart';
import 'consent.dart';
import 'identity.dart';
import 'edgeIdentity.dart';
import 'edgebridge.dart';
import 'userprofile.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
  home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeAEPMobileSdk();
  }

 Future<void> _initializeAEPMobileSdk() async {
    MobileCore.setLogLevel(LogLevel.trace);
    MobileCore.initializeWithAppId(appId:"YOUR_APP_ID");

    // For more granular control over the initial options, you can use the following sample code:
    // InitOptions initOptions = InitOptions(
    //   appId: "YOUR_APP_ID",
    //   lifecycleAutomaticTrackingEnabled: true,
    //   lifecycleAdditionalContextData: {"key": "value"},
    //   appGroupIOS: "group.com.example",
    // );

    // MobileCore.initialize(initOptions: initOptions);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Flutter AEP SDK'),
        ),
        body: Center(
          child: new Column(children: <Widget>[
            Container(
              height: 150,
            ),
            ElevatedButton(
              child: const Text('CORE'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CorePage()));
              },
            ),
            ElevatedButton(
              child: const Text('IDENTITY'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => IdentityPage()));
              },
            ),
            ElevatedButton(
              child: const Text('ASSURANCE'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AssurancePage()));
              },
            ),
            ElevatedButton(
              child: const Text('EDGE'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EdgePage()));
              },
            ),
            ElevatedButton(
              child: const Text('CONSENT'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConsentPage()));
              },
            ),
            ElevatedButton(
              child: const Text('EDGE IDENTITY'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EdgeIdentityPage()));
              },
            ),
            ElevatedButton(
              child: const Text('EDGE BRIDGE'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EdgeBridgePage()));
              },
            ),
            ElevatedButton(
              child: const Text('USER PROFILE'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserProfilePage()));
              },
            ),
            ElevatedButton(
              child: const Text('MESSAGING'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MessagingPage()));
              },
            ),
          ]),
        ));
  }
}
