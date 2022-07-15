import 'package:flutter/material.dart';
import 'core.dart';
import 'assurance.dart';
import 'consent.dart';
import 'identity.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
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
              child: const Text('CONSENT'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConsentPage()));
              },
            ),
          ]),
        ));
  }
}
