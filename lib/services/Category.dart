import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:notes/globals.dart' as globals;

class Category {
  String name;
  int count;
  int id;

  Category(this.id, this.name, this.count);

  Future<void> delete() async {
    await http.delete(
      "${globals.SERVER_ADDRESS}/category/categoryUpdateDestroy/$id",
      headers: {
        "Content-type": "application/json",
        "Authorization": globals.token
      },
    );
  }
}
