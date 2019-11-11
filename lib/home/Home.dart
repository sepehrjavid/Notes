import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/home/CategoryCard.dart';
import 'package:notes/home/NoteCard.dart';
import 'package:notes/services/Category.dart';
import 'package:notes/services/Note.dart';
import 'dart:math' as math;
import 'Heading.dart';
import 'package:notes/globals.dart' as globals;
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  Map<Category, List<Note>> _categories = {};
  int _selectedCategoryIndex = 0;
  int _selectedTabIndex = 0;
  TabController _tabController;
  AnimationController _animationController;
  List _floatingButtonIcons = [Icons.note_add, Icons.category];

  static const int PERFORMED = 2;
  static const int NOTES = 0;
  static const int IMPORTANT = 1;

  Future<void> _getNotesData() async {
    var categoriesJson = await http
        .get("${globals.SERVER_ADDRESS}/category/categoryListCreate", headers: {
      "Content-type": "application/json",
      "Authorization": globals.token
    });
    List categoryList = jsonDecode(categoriesJson.body);
    Map firstCategoryJson = categoryList[0];
    var notesJson = await http.get(
        "${globals.SERVER_ADDRESS}/note/noteListCreate/${firstCategoryJson["id"]}",
        headers: {
          "Content-type": "application/json",
          "Authorization": globals.token
        });
    List categoryNoteList = jsonDecode(notesJson.body);
    setState(() {
      categoryList.forEach((element) {
        Category category =
            Category(element["id"], element["name"], element["count"]);
        _categories[category] = [];
      });
      Category firstCategory = _categories.keys.toList()[0];
      categoryNoteList.forEach((element) {
        Note note = Note(
            element["id"],
            element["title"],
            element["body"],
            DateTime.parse(element["date"]),
            element["isImportant"],
            element["isPerformed"]);
        _categories[firstCategory].add(note);
      });
    });
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
    _tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _getNotesData();
    super.initState();
  }

  Widget _buildCategoryCard(int index, String title, int count) {
    return GestureDetector(
      onTap: () async {
        if (_categories[_categories.keys.toList()[index]].length == 0) {
          Category category = _categories.keys.toList()[index];
          var notesJson = await http.get(
              "${globals.SERVER_ADDRESS}/note/noteListCreate/${category.id}",
              headers: {
                "Content-type": "application/json",
                "Authorization": globals.token
              });
          List categoryNoteList = jsonDecode(notesJson.body);
          setState(() {
            _selectedCategoryIndex = index;
            categoryNoteList.forEach((element) {
              Note note = Note(
                  element["id"],
                  element["title"],
                  element["body"],
                  DateTime.parse(element["date"]),
                  element["isImportant"],
                  element["isPerformed"]);
              _categories[category].add(note);
            });
          });
        } else {
          setState(() {
            _selectedCategoryIndex = index;
          });
        }
      },
      child: CategoryCard(index, _selectedCategoryIndex, title, count),
    );
  }

  Widget _categoryItemBuilder(BuildContext context, int index) {
    return _buildCategoryCard(index, _categories.keys.toList()[index].name,
        _categories.keys.toList()[index].count);
  }

  void _deleteNote(Note note, BuildContext context) {
    int index =
        _categories.values.toList()[_selectedCategoryIndex].indexOf(note);
    setState(() {
      _categories.values.toList()[_selectedCategoryIndex].remove(note);
      _categories.keys.toList()[_selectedCategoryIndex].count -= 1;
    });
    Scaffold.of(context)
        .showSnackBar(SnackBar(
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
                _categories.keys.toList()[_selectedCategoryIndex].count += 1;
              });
            },
          ),
        ))
        .closed
        .timeout(Duration(seconds: 4), onTimeout: () {
      note.deleteNote();
      return;
    });
  }

  void _toggleImportant(Note note) async {
    await note.toggleImportant();
    setState(() {});
  }

  void _togglePerformed(Note note) async {
    await note.togglePerformed();
    setState(() {});
  }

  void _addNote(Category category, BuildContext context) {
    Note note = Note(
      null,
      "",
      "",
      DateTime.now(),
      false,
      false,
    );
    _categories[category].add(note);
    category.count += 1;
    Navigator.pushNamed(context, "/noteDetail", arguments: {
      "note": note,
      "categoryId": _categories.keys.toList()[_selectedCategoryIndex].id,
    });
  }

  Future<void> _showAddCategoryDialog() {
    TextEditingController textController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Category Name:"),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              Container(
                width: 200,
                height: 40,
                decoration: BoxDecoration(
                  color: Color(0xFF417BFB),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FlatButton.icon(
                  onPressed: () async {
                    String newCategoryName = textController.text.toString();
                    var categoryJson = await http.post(
                        "${globals.SERVER_ADDRESS}/category/categoryListCreate",
                        headers: {
                          "Content-type": "application/json",
                          "Authorization": globals.token
                        },
                        body: jsonEncode({"name": newCategoryName}));
                    Map categoryMap = jsonDecode(categoryJson.body);
                    Category category = Category(categoryMap["id"],
                        categoryMap["name"], categoryMap["count"]);
                    setState(() {
                      _categories[category] = [];
                      _selectedCategoryIndex =
                          _categories.keys.toList().indexOf(category);
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.add_box),
                  label: Text("Add"),
                  textColor: Colors.white,
                ),
              ),
              SizedBox(
                width: 22,
              ),
            ],
          );
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
          curve: Interval(0.0, 1.0 - index / _floatingButtonIcons.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Colors.teal[400],
          mini: true,
          child: Icon(_floatingButtonIcons[index], color: Colors.white),
          onPressed: () {
            if (index == 0) {
              _addNote(
                  _categories.keys.toList()[_selectedCategoryIndex], context);
            } else if (index == 1) {
              _showAddCategoryDialog();
            }
            _animationController.reverse();
          },
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
                      transform: Matrix4.rotationZ(
                          _animationController.value * 0.5 * math.pi),
                      alignment: FractionalOffset.center,
                      child: Icon(_animationController.isDismissed
                          ? Icons.add
                          : Icons.close),
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
            child: _categories.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: _categoryItemBuilder,
                  )
                : Center(
                    child: Text(
                      "No Categories Yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
            child: _categories.isNotEmpty
                ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _getNoteBySelectedTab().length,
                    itemBuilder: (context, index) => NoteCard(
                      _getNoteBySelectedTab()[index],
                      _deleteNote,
                      _toggleImportant,
                      _togglePerformed,
                    ),
                  )
                : Center(
                    child: Text(
                      "No Notes Yet",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
