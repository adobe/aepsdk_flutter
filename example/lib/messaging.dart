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
import 'package:flutter_aepmessaging/flutter_aepmessaging.dart';
import 'util.dart';

class MessagingPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MessagingPage> {
  String _messagingVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String messagingVersion;

    messagingVersion = await Messaging.extensionVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }
    setState(() {
      _messagingVersion = messagingVersion;
    });
  }

  Future<void> refreshMessages() async {
    Messaging.refreshInAppMessages();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Messaging Screen")),
        body: Center(
          child: ListView(shrinkWrap: true, children: <Widget>[
            getRichText(
                'AEPMessaging extension version: ', '$_messagingVersion\n'),
            ElevatedButton(
              child: Text("Messaging.refreshMessages(...)"),
              onPressed: () => refreshMessages(),
            ),
          ]),
        ),
      );
}