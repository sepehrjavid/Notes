import 'package:flutter/material.dart';

class SignUpTextField extends StatelessWidget {
  final String _placeHolder;
  TextEditingController _textController;


  SignUpTextField(this._placeHolder, this._textController);

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
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: TextField(
          controller: _textController,
          decoration: InputDecoration(
              hintText: _placeHolder,
              border: InputBorder.none,
              focusColor: Color(0xFF417BFB)),
        ),
      ),
    );
  }
}
