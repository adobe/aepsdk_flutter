/*
Copyright 2025 Adobe. All rights reserved.
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
import 'package:flutter_aepoptimize/flutter_aepoptimize.dart';
import 'util.dart';

class OptimizePage extends StatefulWidget {
  @override
  _OptimizePageState createState() => _OptimizePageState();
}

class _OptimizePageState extends State<OptimizePage> {
  String _optimizeVersion = 'Unknown';
  String _propositionsResult = '';
  String _listenerResult = '';
  String _trackingResult = '';
  List<Offer> _lastOffers = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    late String optimizeVersion;

    try {
      optimizeVersion = await Optimize.extensionVersion;
    } on PlatformException {
      log("Failed to get Optimize extension version");
      optimizeVersion = 'Unknown';
    }

    if (!mounted) return;

    setState(() {
      _optimizeVersion = optimizeVersion;
    });
  }

  Future<void> updatePropositions() async {
    final scopes = [
      DecisionScope('akhil-test-mbox'),
    ];

    try {
      final result = await Optimize.updatePropositions(
        scopes,
        xdm: {'eventType': 'personalization.request'},
        data: {'dataKey': 'dataValue'},
      );

      if (!mounted) return;

      setState(() {
        if (result != null) {
          _lastOffers = result.values.expand((p) => p.offers).toList();
          _propositionsResult =
              'Received ${result.length} scope(s):\n${result.entries.map((e) => '  ${e.key.name}: ${e.value.offers.length} offer(s)').join('\n')}';
        } else {
          _propositionsResult = 'No propositions returned';
        }
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _propositionsResult = 'Error: ${e.message}';
      });
    }
  }

  Future<void> updatePropositionsWithTimeout() async {
    final scopes = [
      DecisionScope('xcore:offer-activity:1111111111111111'),
    ];

    try {
      final result = await Optimize.updatePropositions(
        scopes,
        timeout: 5.0,
      );

      if (!mounted) return;

      setState(() {
        _propositionsResult = result != null
            ? 'Received ${result.length} scope(s) (with timeout)'
            : 'No propositions returned (with timeout)';
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _propositionsResult = 'Error: ${e.message}';
      });
    }
  }

  Future<void> getPropositions() async {
    final scopes = [
      DecisionScope('akhil-test-mbox'),
    ];

    try {
      final result = await Optimize.getPropositions(scopes);

      if (!mounted) return;

      setState(() {
        _propositionsResult = result != null
            ? 'Cached ${result.length} scope(s):\n${result.entries.map((e) => '  ${e.key.name}: ${e.value.offers.length} offer(s)').join('\n')}'
            : 'No cached propositions';
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _propositionsResult = 'Error: ${e.message}';
      });
    }
  }

  void registerPropositionsListener() {
    Optimize.onPropositionsUpdate((propositions) {
      if (!mounted) return;
      setState(() {
        _listenerResult =
            'Listener fired: ${propositions.length} scope(s) updated';
      });
    });

    setState(() {
      _listenerResult = 'Listener registered';
    });
  }

  Future<void> clearCachedPropositions() async {
    await Optimize.clearCachedPropositions();

    if (!mounted) return;

    setState(() {
      _propositionsResult = 'Cache cleared';
    });
  }

  Future<void> updateWithActivityPlacement() async {
    final scope = DecisionScope.fromActivityAndPlacement(
      activityId: 'xcore:offer-activity:1111111111111111',
      placementId: 'xcore:offer-placement:2222222222222222',
    );

    try {
      final result = await Optimize.updatePropositions([scope]);

      if (!mounted) return;

      setState(() {
        _propositionsResult = result != null
            ? 'Activity/Placement: ${result.length} scope(s)'
            : 'No propositions returned';
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      setState(() {
        _propositionsResult = 'Error: ${e.message}';
      });
    }
  }

  // --- Offer instance tracking ---

  Future<void> offerDisplayed() async {
    if (_lastOffers.isEmpty) {
      setState(() => _trackingResult = 'No offers — call updatePropositions first');
      return;
    }
    await _lastOffers.first.displayed();
    if (!mounted) return;
    setState(() => _trackingResult = 'offer.displayed() sent for "${_lastOffers.first.id}"');
  }

  Future<void> offerTapped() async {
    if (_lastOffers.isEmpty) {
      setState(() => _trackingResult = 'No offers — call updatePropositions first');
      return;
    }
    await _lastOffers.first.tapped();
    if (!mounted) return;
    setState(() => _trackingResult = 'offer.tapped() sent for "${_lastOffers.first.id}"');
  }

  Future<void> offerGenerateDisplayXdm() async {
    if (_lastOffers.isEmpty) {
      setState(() => _trackingResult = 'No offers — call updatePropositions first');
      return;
    }
    final xdm = await _lastOffers.first.generateDisplayInteractionXdm();
    if (!mounted) return;
    setState(() => _trackingResult = 'generateDisplayInteractionXdm:\n$xdm');
  }

  Future<void> offerGenerateTapXdm() async {
    if (_lastOffers.isEmpty) {
      setState(() => _trackingResult = 'No offers — call updatePropositions first');
      return;
    }
    final xdm = await _lastOffers.first.generateTapInteractionXdm();
    if (!mounted) return;
    setState(() => _trackingResult = 'generateTapInteractionXdm:\n$xdm');
  }

  // --- Batch (static) tracking ---

  Future<void> batchDisplayed() async {
    if (_lastOffers.isEmpty) {
      setState(() => _trackingResult = 'No offers — call updatePropositions first');
      return;
    }
    await Optimize.displayed(_lastOffers);
    if (!mounted) return;
    setState(() => _trackingResult = 'Optimize.displayed() sent for ${_lastOffers.length} offer(s)');
  }

  Future<void> batchGenerateDisplayXdm() async {
    if (_lastOffers.isEmpty) {
      setState(() => _trackingResult = 'No offers — call updatePropositions first');
      return;
    }
    final xdm = await Optimize.generateDisplayInteractionXdm(_lastOffers);
    if (!mounted) return;
    setState(() => _trackingResult = 'Optimize.generateDisplayInteractionXdm:\n$xdm');
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text("Optimize Screen")),
      body: Center(
        child: ListView(shrinkWrap: true, children: <Widget>[
          getRichText(
              'AEPOptimize extension version: ', '$_optimizeVersion\n'),
          getRichText('Propositions result: ', '$_propositionsResult\n'),
          getRichText('Listener status: ', '$_listenerResult\n'),
          getRichText('Tracking result: ', '$_trackingResult\n'),
          ElevatedButton(
            child: Text("updatePropositions"),
            onPressed: () => updatePropositions(),
          ),
          ElevatedButton(
            child: Text("updatePropositions (with timeout)"),
            onPressed: () => updatePropositionsWithTimeout(),
          ),
          ElevatedButton(
            child: Text("updatePropositions (activity/placement)"),
            onPressed: () => updateWithActivityPlacement(),
          ),
          ElevatedButton(
            child: Text("getPropositions (from cache)"),
            onPressed: () => getPropositions(),
          ),
          ElevatedButton(
            child: Text("registerOnPropositionsUpdate"),
            onPressed: () => registerPropositionsListener(),
          ),
          ElevatedButton(
            child: Text("clearCachedPropositions"),
            onPressed: () => clearCachedPropositions(),
          ),
          Divider(thickness: 2, height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Offer Tracking (uses first offer from last updatePropositions)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          ElevatedButton(
            child: Text("offer.displayed()"),
            onPressed: () => offerDisplayed(),
          ),
          ElevatedButton(
            child: Text("offer.tapped()"),
            onPressed: () => offerTapped(),
          ),
          ElevatedButton(
            child: Text("offer.generateDisplayInteractionXdm()"),
            onPressed: () => offerGenerateDisplayXdm(),
          ),
          ElevatedButton(
            child: Text("offer.generateTapInteractionXdm()"),
            onPressed: () => offerGenerateTapXdm(),
          ),
          Divider(thickness: 2, height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Batch Tracking (all offers from last updatePropositions)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          ),
          ElevatedButton(
            child: Text("Optimize.displayed(offers)"),
            onPressed: () => batchDisplayed(),
          ),
          ElevatedButton(
            child: Text("Optimize.generateDisplayInteractionXdm(offers)"),
            onPressed: () => batchGenerateDisplayXdm(),
          ),
        ]),
      ));
}
