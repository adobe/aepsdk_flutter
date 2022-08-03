import 'package:flutter/material.dart';

// UTIL
RichText getRichText(String label, String value) {
  return new RichText(
    text: new TextSpan(
      // Note: Styles for TextSpans must be explicitly defined.
      // Child text spans will inherit styles from parent
      style: new TextStyle(
        fontSize: 14.0,
        color: Colors.black,
      ),
      children: <TextSpan>[
        new TextSpan(
            text: label, style: new TextStyle(fontWeight: FontWeight.bold)),
        new TextSpan(text: value),
      ],
    ),
  );
}
