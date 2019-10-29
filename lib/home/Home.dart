import 'package:flutter/material.dart';
import 'package:notes/home/CategoryCard.dart';
import 'package:notes/home/NoteCard.dart';
import 'package:notes/services/Note.dart';
import 'dart:math' as math;
import 'Heading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Map<String, List> _categories = {"work": [], "personal": [], "poems": []};
  int _selectedCategoryIndex = 0;
  int _selectedTabIndex = 0;
  TabController _tabController;
  AnimationController _animationController;
  List _floatingButtonIcons = [Icons.note_add, Icons.category];

  static const int PERFORMED = 2;
  static const int NOTES = 0;
  static const int IMPORTANT = 1;

  List _notes = [
    Note(
      "first note",
      "I'm the first note and I'd like to be the longest note ever on a test",
      "work",
      DateTime.now(),
      true,
      false,
    ),
    Note(
      "second note",
      "I'm the second note",
      "personal",
      DateTime.now().add(
        Duration(hours: -2),
      ),
      true,
      false,
    ),
    Note(
      "third note",
      "Third note",
      "poems",
      DateTime.now(),
      true,
      false,
    ),
    Note(
      "fourth note",
      "I'm the fourth note and I'd like to be the longest note ever on a test",
      "work",
      DateTime.now(),
      false,
      false,
    ),
  ];

  void _getNotesData() {
    _notes.forEach((element) {
      _categories[element.category].add(element);
    });
    _notes.clear();
  }

  List _getNoteBySelectedTab() {
    if (_selectedTabIndex == PERFORMED) {
      return _categories.values
          .toList()[_selectedCategoryIndex]
          .where((element) => element.isPerformed)
          .toList();
    } else if (_selectedTabIndex == IMPORTANT) {
      return _categories.values
          .toList()[_selectedCategoryIndex]
          .where((element) => element.isImportant)
          .toList();
    } else if (_selectedTabIndex == NOTES) {
      return _categories.values.toList()[_selectedCategoryIndex];
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _getNotesData();
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
    return _buildCategoryCard(index, _categories.keys.toList()[index],
        _categories.values.toList()[index].length);
  }

  void _deleteNote(Note note, BuildContext context) {
    int index =
        _categories.values.toList()[_selectedCategoryIndex].indexOf(note);
    setState(() {
      _categories.values.toList()[_selectedCategoryIndex].remove(note);
    });
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        "${note.title} deleted!",
        style: TextStyle(fontSize: 16),
      ),
      action: SnackBarAction(
        label: "Undo",
        onPressed: () {
          setState(() {
            _categories.values
                .toList()[_selectedCategoryIndex]
                .insert(index, note);
          });
        },
      ),
    ));
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

  Widget _generateFloatingButtonIconList(int index) {
    Widget child = Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _animationController,
          curve: Interval(
              0.0, 1.0 - index / _floatingButtonIcons.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.teal[400],
          mini: true,
          child: Icon(_floatingButtonIcons[index], color: Colors.white),
          onPressed: () {},
        ),
      ),
    );
    return child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
                _floatingButtonIcons.length, _generateFloatingButtonIconList)
            .toList()
              ..add(FloatingActionButton(
                heroTag: null,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget child) {
                    return Transform(
                      transform: new Matrix4.rotationZ(_animationController.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: Icon(_animationController.isDismissed ? Icons.add : Icons.close),
                    );
                  },
                ),
                onPressed: () {
                  if (_animationController.isDismissed) {
                    _animationController.forward();
                  } else {
                    _animationController.reverse();
                  }
                },
              )),
      ),
      backgroundColor: Colors.grey[300],
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Heading(),
          Container(
            height: 245,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: categoryItemBuilder,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              onTap: (selectedIndex) {
                setState(() {
                  _selectedTabIndex = selectedIndex;
                });
              },
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
                itemCount: _getNoteBySelectedTab().length,
                itemBuilder: (context, index) => NoteCard(
                      _getNoteBySelectedTab()[index],
                      _deleteNote,
                      _toggleImportant,
                      _togglePerformed,
                    )),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
