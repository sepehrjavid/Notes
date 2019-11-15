import 'package:flutter/material.dart';
import 'package:notes/login/Login.dart';
import 'package:notes/signup/SignUp.dart';
import 'home/Home.dart';
import 'note_detail/NoteDetail.dart';

void main() => runApp(Notes());

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/signup",
      routes: {
        "/": (context) => Home(),
        "/login": (context) => Login(),
        "/signup": (context) => SignUp(),
        "/noteDetail": (context) => NoteDetail(),
      },
    );
  }
}
