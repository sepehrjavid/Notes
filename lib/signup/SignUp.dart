import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/signup/SignUpTextField.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:notes/globals.dart' as globals;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {
  bool _loading = false;

  TextEditingController _usernameController = TextEditingController();

  TextEditingController _firstNameController = TextEditingController();

  TextEditingController _lastNameController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  TextEditingController _confirmPasswordController = TextEditingController();

  void _signUp() {
    Map requestJson = {
      "username": _usernameController.text,
      "first_name": _firstNameController.text,
      "last_name": _lastNameController.text,
      "password": _passwordController.text,
      "confirmPassword": _confirmPasswordController.text
    };

    Future<Map> response = _sendRequest(requestJson);

    response.then((value) {
      setState(() {
        _loading = false;
      });
      if (value["id"] == null) {
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
  }

  Future<Map> _sendRequest(Map requestJson) async {
    var response = await http.post(
        "${globals.SERVER_ADDRESS}/accounting/signup",
        body: jsonEncode(requestJson),
        headers: {
          "Content-type": "application/json",
        });
    return jsonDecode(response.body);
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
                SizedBox(height: 20),
                SignUpTextField("Username", _usernameController),
                SizedBox(height: 20),
                SignUpTextField("First Name", _firstNameController),
                SizedBox(height: 20),
                SignUpTextField("Last Name", _lastNameController),
                SizedBox(height: 20),
                SignUpTextField("Password", _passwordController),
                SizedBox(height: 20),
                SignUpTextField("Confirm Password", _confirmPasswordController),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _loading = true;
                      _signUp();
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
                                "Sign Up",
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
                      "Already have an account?",
                      style: TextStyle(
                        color: Color(0xFFF5F7FB),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacementNamed("/login");
                      },
                      child: Text(
                        "Login",
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
