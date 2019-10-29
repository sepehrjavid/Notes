import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/home/CategoryCard.dart';
import 'package:notes/home/NoteCard.dart';
import 'package:notes/services/Note.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Map categories = {"work": 250, "personal": 10, "poems": 5, "simple text": 5};
  List notes = [
    Note(
      "first note",
      "I'm the first note and I'd like to be the longest note ever on a test",
      DateTime.now(),
      true,
      false,
    ),
    Note(
      "second note",
      "I'm the second note",
      DateTime.now().add(
        Duration(hours: -2),
      ),
      true,
      false,
    ),
    Note(
      "third note",
      "Third note",
      DateTime.now(),
      true,
      false,
    ),
    Note(
      "fourth note",
      "I'm the fourth note and I'd like to be the longest note ever on a test",
      DateTime.now(),
      false,
      false,
    ),
  ];
  int _selectedCategoryIndex = 0;

  TabController _tabController;

//  final DateFormat _dateFormatter = DateFormat("dd MMM");
  final DateFormat _timeFormatter = DateFormat("h:mm");

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  Widget _buildCategoryCard(int index, String title, int count) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryIndex = index;
        });
      },
      child: CategoryCard(index, _selectedCategoryIndex, title, count),
    );
  }

  Widget categoryItemBuilder(BuildContext context, int index) {
    return _buildCategoryCard(index, categories.keys.toList()[index],
        categories.values.toList()[index]);
  }

  void _deleteNote(Note note) {
    setState(() {
      notes.remove(note);
    });
  }

  void _toggleImportant(Note note) {
    setState(() {
      note.isImportant = !note.isImportant;
    });
  }

  void _togglePerformed(Note note) {
    setState(() {
      note.isPerformed = !note.isPerformed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/slm.png"),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Sepehr Javid",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 245,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: categoryItemBuilder,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Color(0xFFAFB4C6),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 4,
              isScrollable: true,
              tabs: <Widget>[
                Tab(
                  child: Text(
                    "Notes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Important",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    "Performed",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 250,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: notes.length,
                itemBuilder: (context, index) => NoteCard(
                      notes[index],
                      _deleteNote,
                      _toggleImportant,
                      _togglePerformed,
                    )),
          ),
          SizedBox(height: 10)
        ],
      ),
    );
  }
}
