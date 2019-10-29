import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final int _index;
  final int _selectedCategoryIndex;
  final int count;
  final String _title;

  CategoryCard(
      this._index, this._selectedCategoryIndex, this._title, this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: 145,
      decoration: BoxDecoration(
          color: _selectedCategoryIndex == _index
              ? Color(0xFF417BFB)
              : Color(0xFFF5F7FB),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            _selectedCategoryIndex == _index
                ? BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 5),
                    blurRadius: 10,
                  )
                : BoxShadow(color: Colors.transparent)
          ]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              _title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 23,
                color: _selectedCategoryIndex == _index
                    ? Colors.white
                    : Color(0xFFAFB4c6),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              count.toString(),
              style: TextStyle(
                  color: _selectedCategoryIndex == _index
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          )
        ],
      ),
    );
  }
}
