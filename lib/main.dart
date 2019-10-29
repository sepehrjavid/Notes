import 'package:flutter/material.dart';
import 'home/Home.dart';
import 'note_detail/NoteDetail.dart';

void main() => runApp(Notes());

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => Home(),
        "/noteDetail": (context) => NoteDetail(),
      },
    );
  }
}
