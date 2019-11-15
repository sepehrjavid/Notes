import 'package:flutter/material.dart';
import 'package:notes/login/PasswordField.dart';

import 'LoginButton.dart';
import 'UsernameField.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
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
            UsernameField(),
            SizedBox(height: 20),
            PasswordField(),
            SizedBox(height: 20),
            LoginButton(),
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
    );
  }
}
