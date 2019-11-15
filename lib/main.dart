import 'package:flutter/material.dart';
import 'package:notes/login/Login.dart';
import 'package:notes/signup/SignUp.dart';
import 'home/Home.dart';
import 'note_detail/NoteDetail.dart';
import 'package:notes/globals.dart' as globals;

void main() => runApp(Notes());

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: globals.token == null ? "/login" : "/",
      routes: {
        "/login": (context) => Login(),
        "/signup": (context) => SignUp(),
        "/": (context) => Home(),
        "/noteDetail": (context) => NoteDetail(),
      },
    );
  }
}
