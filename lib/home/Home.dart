import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notes/home/CategoryCard.dart';
import 'package:notes/home/NoteCard.dart';
import 'package:notes/services/Category.dart';
import 'package:notes/services/Note.dart';
import 'AddCategoryCard.dart';
import 'AddNoteCard.dart';
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
    if (categoryList.length != 0) {
      Map lastCategoryJson = categoryList.last;
      var notesJson = await http.get(
          "${globals.SERVER_ADDRESS}/note/noteListCreate/${lastCategoryJson["id"]}",
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
        Category lastCategory = _categories.keys.toList().last;
        _selectedCategoryIndex =
            _categories.keys.toList().indexOf(lastCategory);
        categoryNoteList.forEach((element) {
          Note note = Note(
              element["id"],
              element["title"],
              element["body"],
              DateTime.parse(element["date"]),
              element["isImportant"],
              element["isPerformed"]);
          _categories[lastCategory].add(note);
        });
      });
    }
  }

  List _getNoteBySelectedTab() {
    if (_categories.length == 0) {
      return [];
    }
    if (_selectedTabIndex == PERFORMED) {
      return _categories.values
          .toList()[_selectedCategoryIndex]
          .where((element) => element.isPerformed)
          .toList()
            ..sort((a, b) {
              return -a.date.compareTo(b.date);
            });
    } else if (_selectedTabIndex == IMPORTANT) {
      return _categories.values
          .toList()[_selectedCategoryIndex]
          .where((element) => element.isImportant)
          .toList()
            ..sort((a, b) {
              return -a.date.compareTo(b.date);
            });
    } else if (_selectedTabIndex == NOTES) {
      return _categories.values.toList()[_selectedCategoryIndex]
        ..sort((a, b) {
          return -a.date.compareTo(b.date);
        });
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
    return Dismissible(
      key: Key(title),
      direction: DismissDirection.up,
      onDismissed: (direction) {
        if (index == _selectedCategoryIndex) {
          Category category = _categories.keys.toList()[index];
          setState(() {
            _categories.remove(category);
            _selectedCategoryIndex = _categories.keys.toList().length - 1;
          });
          category.delete();
        }
      },
      child: GestureDetector(
        onTap: () async {
          Category category = _categories.keys.toList()[index];
          if (_categories[category].length == 0) {
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
      ),
    );
  }

  Widget _categoryItemBuilder(int index) {
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
            "${note.title} was deleted!",
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
        .timeout(Duration(seconds: 4), onTimeout: () async {
      await note.delete();
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

  void _addNote(Category category) {
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
                    Category newCategory = Category(null, newCategoryName, 0);
                    newCategory.store();
                    setState(() {
                      _categories[newCategory] = [];
                      _selectedCategoryIndex =
                          _categories.keys.toList().indexOf(newCategory);
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

  Widget _noteGenerator(int index) {
    return NoteCard(
      _getNoteBySelectedTab()[index],
      _deleteNote,
      _toggleImportant,
      _togglePerformed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20),
          Heading(),
          Container(
            height: 245,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(_categories.length, _categoryItemBuilder)
                  .reversed
                  .toList()
                    ..insert(0, AddCategoryCard(_showAddCategoryDialog)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.grey[200],
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
            height: 285,
            child: ListView(
              scrollDirection: Axis.vertical,
              children:
                  List.generate(_getNoteBySelectedTab().length, _noteGenerator)
                      .toList()
                        ..insert(
                            0,
                            AddNoteCard(
                              _addNote,
                              _selectedCategoryIndex,
                              _categories,
                            )),
            ),
          ),
        ],
      ),
    );
  }
}
