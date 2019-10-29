import 'package:flutter/material.dart';
import 'package:notes/services/Note.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NoteCard extends StatelessWidget {
  final Note _note;
  final Function _deleteNote;
  final Function _toggleImportant;
  final Function _togglePerformed;

  final DateFormat _dateFormat = DateFormat("yyyy MMM, dd HH:mm");

  NoteCard(
    this._note,
    this._deleteNote,
    this._toggleImportant,
    this._togglePerformed,
  );

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/noteDetail",
            arguments: {"note": _note},
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Color(0xFFF5F7FB),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    _note.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _dateFormat.format(_note.date),
                    style: TextStyle(
                      color: Color(0xFFAFB4C6),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 7),
              _note.body.length <= 30
                  ? Text(_note.body.substring(0, _note.body.length))
                  : Text(_note.body.substring(0, 31) + "...")
            ],
          ),
        ),
      ),
      actions: <Widget>[
        _note.isPerformed
            ? IconSlideAction(
                caption: 'Not Performed',
                color: Colors.red[800],
                icon: Icons.clear,
                onTap: () => _togglePerformed(_note),
              )
            : IconSlideAction(
                caption: 'Performed',
                color: Colors.green,
                icon: Icons.done,
                onTap: () => _togglePerformed(_note),
              ),
        _note.isImportant
            ? IconSlideAction(
                caption: 'Not Important',
                color: Colors.orange[400],
                icon: Icons.star_border,
                onTap: () => _toggleImportant(_note),
              )
            : IconSlideAction(
                caption: 'Important',
                color: Colors.yellow[500],
                icon: Icons.star,
                onTap: () => _toggleImportant(_note),
              ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => _deleteNote(_note, context),
        ),
      ],
    );
  }
}
