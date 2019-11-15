import 'package:flutter/material.dart';
import 'package:notes/globals.dart' as globals;

class Heading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Hi ${globals.fullName}",
            style: TextStyle(
              fontFamily: "LibreBaskerville",
              fontSize: 20,
              color: Colors.grey[200],
            ),
          ),
        ],
      ),
    );
  }
}
