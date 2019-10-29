import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NoteDetail extends StatelessWidget {
  Map data;
  DateFormat dateFormat = DateFormat("yyyy MMM, dd HH:mm");

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text(
          dateFormat.format(data["note"].date),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[850],
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                fontFamily: "LibreBaskerville",
                fontSize: 27,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: null,
              minLines: null,
              initialValue: data["note"].title,
            ),
            Divider(
              height: 10,
              color: Colors.grey[800],
            ),
            TextFormField(
              style: TextStyle(
                fontFamily: "LibreBaskerville",
                fontSize: 19,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.3,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: null,
              minLines: null,
              initialValue: data["note"].body,
            ),
          ],
        ),
      ),
    );
  }
}
