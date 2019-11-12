import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            "Notes",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.grey[200],
            ),
          ),
          SizedBox(width: 4),
          Text(
            "by SepehrJavid",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
