import 'package:flutter/material.dart';

class UsernameField extends StatelessWidget {
  final TextEditingController _usernameTextController;

  UsernameField(this._usernameTextController);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 50,
      decoration: BoxDecoration(
        color: Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: _usernameTextController,
          decoration: InputDecoration(
              hintText: "Username",
              icon: Icon(Icons.person),
              border: InputBorder.none,
              focusColor: Color(0xFF417BFB)),
        ),
      ),
    );
  }
}
