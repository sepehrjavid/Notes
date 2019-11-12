import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/services/Note.dart';

class NoteDetail extends StatelessWidget {
  Map data;
  final DateFormat _dateFormat = DateFormat("yyyy MMM, dd HH:mm");
  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _bodyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    Note note = data["note"];
    int categoryId = data["categoryId"];
    _titleTextController.text = note.title;
    _bodyTextController.text = note.body;


    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Text(
          _dateFormat.format(note.date),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[850],
          ),
        ),
        centerTitle: true,
        leading: GestureDetector(
          onTap: () async {
            note.body = _bodyTextController.text.toString();
            note.title = _titleTextController.text.toString();
            await note.store(categoryId);
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                fontFamily: "LibreBaskerville",
                fontSize: 27,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: null,
              minLines: null,
              controller: _titleTextController,
            ),
            Divider(
              height: 10,
              color: Colors.grey[800],
            ),
            TextFormField(
              style: TextStyle(
                fontFamily: "LibreBaskerville",
                fontSize: 19,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.3,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              maxLines: null,
              minLines: null,
              controller: _bodyTextController,
            ),
          ],
        ),
      ),
    );
  }
}
