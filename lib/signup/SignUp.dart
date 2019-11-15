import 'package:flutter/material.dart';
import 'package:notes/signup/SignUpButton.dart';
import 'package:notes/signup/SignUpTextField.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            SignUpTextField("Username"),
            SizedBox(height: 20),
            SignUpTextField("First Name"),
            SizedBox(height: 20),
            SignUpTextField("Last Name"),
            SizedBox(height: 20),
            SignUpTextField("Password"),
            SizedBox(height: 20),
            SignUpTextField("Confirm Password"),
            SizedBox(height: 20),
            SignUpButton(),
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
    );
  }
}
