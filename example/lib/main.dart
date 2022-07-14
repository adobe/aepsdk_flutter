import 'package:flutter/material.dart';
import 'core.dart';
import 'assurance.dart';
import 'consent.dart';
import 'identity.dart';

void main() {
  runApp(MaterialApp(
    home: homePage(),
  ));
}

class homePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Flutter AEP SDK'),
        ),
        body: Center(
          child: new Column(children: <Widget>[
            ElevatedButton(
              child: const Text('CORE'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => corePage()));
              },
            ),
            ElevatedButton(
              child: const Text('IDENTITY'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => identityPage()));
              },
            ),
            ElevatedButton(
              child: const Text('ASSURANCE'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => assurancePage()));
              },
            ),
            ElevatedButton(
              child: const Text('CONSENT'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => consentPage()));
              },
            ),
          ]),
        ));
  }
}
