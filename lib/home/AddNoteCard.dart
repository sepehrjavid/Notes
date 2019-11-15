import 'package:flutter/material.dart';

class AddNoteCard extends StatelessWidget {
  final Function _addNote;
  final int _selectedCategoryIndex;
  final Map _category;

  AddNoteCard(this._addNote, this._selectedCategoryIndex, this._category);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_category.length != 0) {
          _addNote(_category.keys.toList()[_selectedCategoryIndex]);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.add_circle,
          color: Color(0xFFAFB4c6),
          size: 60,
        ),
      ),
    );
  }
}
