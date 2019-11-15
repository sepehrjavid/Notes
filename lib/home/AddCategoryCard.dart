import 'package:flutter/material.dart';

class AddCategoryCard extends StatelessWidget {
  final Function _showAddCategoryDialog;

  AddCategoryCard(this._showAddCategoryDialog);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showAddCategoryDialog();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        width: 145,
        decoration: BoxDecoration(
          color: Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.transparent)],
        ),
        child: Center(
          child: Icon(
            Icons.add_circle,
            color: Color(0xFFAFB4c6),
            size: 60,
          ),
        ),
      ),
    );
  }
}
