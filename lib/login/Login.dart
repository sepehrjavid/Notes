import 'dart:convert';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:notes/login/PasswordField.dart';
import 'package:http/http.dart' as http;
import 'package:notes/globals.dart' as globals;

import 'UsernameField.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  final TextEditingController _usernameTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  bool _loading = false;

  void _login() {
    Future<Map> response = _sendLoginRequest(
        _usernameTextController.text, _passwordTextController.text);
    response.then((value) {
      setState(() {
        _loading = false;
      });
      if (value["token"] == null) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.grey[800],
                content: Row(
                  children: <Widget>[
                    Icon(
                      Icons.info,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Invalid Username Or Password",
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )
                  ],
                ),
                actions: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, right: 15, top: 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Try Again",
                        style: TextStyle(
                          color: Color(0xFF417BFB),
                          fontSize: 17,
                        ),
                      ),
                    ),
                  )
                ],
              );
            });
      } else {
        globals.token = "JWT ${value["token"]}";
        globals.fullName = value["fullName"];
        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  Future<Map> _sendLoginRequest(String username, String password) async {
    Map requestJson = {"username": username, "password": password};

    var responseJson = await http.post("${globals.SERVER_ADDRESS}/login",
        body: jsonEncode(requestJson),
        headers: {
          "Content-type": "application/json",
        });

    return jsonDecode(responseJson.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Welcome To Notes",
                  style: TextStyle(
                    color: Color(0xFFF5F7FB),
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: "LibreBaskerville",
                  ),
                ),
                SizedBox(height: 90),
                UsernameField(_usernameTextController),
                SizedBox(height: 20),
                PasswordField(_passwordTextController),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _loading = true;
                      _login();
                    });
                  },
                  child: Container(
                    width: 340,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xFF417BFB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Center(
                        child: !_loading
                            ? Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "LibreBaskerville",
                                ),
                              )
                            : SpinKitThreeBounce(
                                color: Colors.white,
                                size: 30.0,
                                controller: AnimationController(
                                    vsync: this,
                                    duration:
                                        const Duration(milliseconds: 1200)),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Color(0xFFF5F7FB),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("/signup");
                      },
                      child: Text(
                        "Sing Up",
                        style: TextStyle(
                          color: Color(0xFF417BFB),
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
