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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepcore/flutter_aepcore.dart';
import 'package:flutter_aepcore/flutter_aepcore_data.dart';
import 'package:flutter_aepmessaging/flutter_aepmessaging.dart';
import 'util.dart';

class CustomMessagingDelegate implements MessagingDelegate {
  @override
  void onDismiss(Showable message) {
    print('$message');
  }

  @override
  onShow(Showable message) async {
    print('$message');
  }

  @override
  bool shouldSaveMessage(Showable message) {
    return true;
  }

  @override
  bool shouldShowMessage(Showable message) {
    return true;
  }

  @override
  void urlLoaded(String url, Showable message) {
    print(url);
    print(message);
  }
}

class MessagingPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MessagingPage> {
  String _messagingVersion = 'Unknown';
  List<Message> _cachedMessages = [];
  dynamic _propositions = null;
  final TextEditingController inputController = TextEditingController();

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

  getCachedMessages() async {
    var messages = await Messaging.getCachedMessages();
    print('$messages');

    setState(() {
      _cachedMessages = messages;
    });
  }

  Future<void> getPropositionsForSurfaces() async {
    var propositions = await Messaging.getPropositionsForSurfaces(['json']);
    print('$propositions');
    setState(() {
      _propositions = propositions;
    });
  }

  Future<void> refreshMessages() async {
    Messaging.refreshInAppMessages();
  }

  Future<void> updatePropositionsForSurfaces() async {
    Messaging.updatePropositionsForSurfaces(['json']);
  }

  Future<void> showMessage() async {
    if (_cachedMessages.isNotEmpty) {
      var message = _cachedMessages[0];
      message.show();
    }
  }

  Future<void> dismissMessage() async {
    if (_cachedMessages.isNotEmpty) {
      var message = _cachedMessages[0];
      message.dismiss();
    }
  }

  Future<void> trackMessage() async {
    if (_cachedMessages.isNotEmpty) {
      var message = _cachedMessages[0];
      message.track('interaction', MessagingEdgeEventType.IN_APP_TRIGGER);
    }
  }

  Future<void> setAutoTrack() async {
    if (_cachedMessages.isNotEmpty) {
      var message = _cachedMessages[0];
      message.setAutoTrack(false);
    }
  }

  Future<void> clearMessage() async {
    if (_cachedMessages.isNotEmpty) {
      var message = _cachedMessages[0];
      message.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    Messaging.setMessagingDelegate(CustomMessagingDelegate());

    return Scaffold(
      appBar: AppBar(title: Text("Messaging Screen")),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          getRichText(
              'AEPMessaging extension version: ', '$_messagingVersion\n'),
          getRichText('Current Cached Messages: ', '$_cachedMessages\n'),
          getRichText('Current Propositions: ', '$_propositions\n'),
          TextField(
            controller: inputController,
            decoration: InputDecoration(
              labelText: 'Track action name setup in your in-app campaign',
            ),
          ),
          ElevatedButton(
            child: Text("MobileCore.trackAction"),
            onPressed: () =>
                MobileCore.trackAction(inputController.text, data: {
              "testInA": "true",
            }),
          ),
          ElevatedButton(
            child: Text("Messaging.getCachedMessages(...)"),
            onPressed: () => getCachedMessages(),
          ),
          ElevatedButton(
            child: Text("Messaging.getPropositionsForSurfaces(...)"),
            onPressed: () => getPropositionsForSurfaces(),
          ),
          ElevatedButton(
            child: Text("Messaging.refreshMessages(...)"),
            onPressed: () => refreshMessages(),
          ),
          ElevatedButton(
            child: Text("Messaging.updatePropositionsForSurfaces(...)"),
            onPressed: () => updatePropositionsForSurfaces(),
          ),
          Text("Message functions:"),
          Text("Run after getCachedMessages contains message"),
          ElevatedButton(
            child: Text("showMessage"),
            onPressed: () => showMessage(),
          ),
          ElevatedButton(
            child: Text("dismissMessage"),
            onPressed: () => dismissMessage(),
          ),
          ElevatedButton(
            child: Text("setAutoTrack"),
            onPressed: () => setAutoTrack(),
          ),
          ElevatedButton(
            child: Text("trackMessage"),
            onPressed: () => trackMessage(),
          ),
          ElevatedButton(
            child: Text("clearMessage"),
            onPressed: () => clearMessage(),
          ),
        ]),
      ),
    );
  }
}
