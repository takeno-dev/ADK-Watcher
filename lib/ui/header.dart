import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // centers horizontally
      crossAxisAlignment: CrossAxisAlignment.center, // centers vertically
      children: <Widget>[
        Image.asset("assets/adk.png", width: 30, height: 30),
        SizedBox(
          width: 3,
        ), // The size box provides an immediate spacing between the widgets
        Text(
          "ADK Watcher",
        )
      ],
    );
  }
}