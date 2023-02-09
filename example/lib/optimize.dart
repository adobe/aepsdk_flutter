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

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_aepoptimize/flutter_aepoptimize.dart';
import 'util.dart';

class OptimizePage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<OptimizePage> {
  String _optimizeVersion = 'Unknown';
  List<Proposition> _propositions = List.empty();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    late String optimizeVersion;

    optimizeVersion = await Optimize.extensionVersion;

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      log('Failed to setState, widget is not mounted');
      return;
    }

    setState(() {
      _optimizeVersion = optimizeVersion;
    });
  }

  Future<void> getPropositions() async {
    try {
      DecisionScope decisionScope = DecisionScope({
        "name":
            "eyJ4ZG06YWN0aXZpdHlJZCI6Inhjb3JlOm9mZmVyLWFjdGl2aXR5OjE1ZjVlZjdjZDZiOTdlMTAiLCJ4ZG06cGxhY2VtZW50SWQiOiJ4Y29yZTpvZmZlci1wbGFjZW1lbnQ6MTVmNWU5ZDU1ZjJjZmM3ZSJ9",
      });
      List<Proposition> propositions =
          await Optimize.getPropositions([decisionScope]);

      if (!mounted) {
        log('Failed to setState, widget is not mounted');
        return;
      }

      setState(() {
        _propositions = propositions;
        print(
            "Successfully retrieved propositions\n" + propositions.toString());
      });
    } on PlatformException {
      log("Failed to retrieve propositions");
    }
  }

  Future<void> onPropositionsUpdate() async {
    try {
      await Optimize.onPropositionsUpdate();
      log("Successfully added proposition update handler");
    } on PlatformException {
      log("Failed to register proposition update handler");
    }
  }

  Future<void> updatePropositions() async {
    try {
      DecisionScope decisionScope = DecisionScope({
        "name": "myScope",
      });
      await Optimize.updatePropositions([decisionScope], null, null);
      log("Successfully updated propositions");
    } on PlatformException {
      log("Failed to update propositions");
    }
  }

  Future<void> clearCachedPropositions() async {
    try {
      await Optimize.clearCachedPropositions();
      log("Successfully cleared cached propositions");
    } on PlatformException {
      log("Failed to clear cached propositions");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('Optimize Screen')),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          getRichText('AEPOptimize extension version: ', '$_optimizeVersion\n'),
          getRichText('Current Propositions: ', '$_propositions\n'),
          ElevatedButton(
            child: Text("Optimize.getPropositions(...)"),
            onPressed: () => getPropositions(),
          ),
          ElevatedButton(
            child: Text("Optimize.onPropositionsUpdate(...)"),
            onPressed: () => onPropositionsUpdate(),
          ),
          ElevatedButton(
            child: Text("Optimize.updatePropositions(...)"),
            onPressed: () => updatePropositions(),
          ),
          ElevatedButton(
            child: Text("Optimize.clearCachedPropositions(...)"),
            onPressed: () => clearCachedPropositions(),
          ),
        ]),
      ));
}
