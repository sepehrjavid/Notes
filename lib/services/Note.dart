import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:notes/globals.dart' as globals;

class Note {
  int id;
  String title;
  String body;
  DateTime date;
  bool isImportant;
  bool isPerformed;

  Note(this.id,
      this.title,
      this.body,
      this.date,
      this.isImportant,
      this.isPerformed,);

  void storeNote(int categoryId) async {
    Map json = {
      "title": title,
      "body": body,
      "isImportant": isImportant,
      "isPerformed": isPerformed
    };

    if (id == null) {
      var response = await http.post(
        "${globals.SERVER_ADDRESS}/note/noteListCreate/$categoryId",
        headers: {
          "Content-type": "application/json",
          "Authorization": globals.token
        },
        body: jsonEncode(json),
      );

      Map noteJson = jsonDecode(response.body);

      id = noteJson["id"];
      date = DateTime.parse(noteJson["date"]);
    } else {
      var response = await http.put(
        "${globals.SERVER_ADDRESS}/note/noteRetrieveUpdateDestroy/$id",
        headers: {
          "Content-type": "application/json",
          "Authorization": globals.token
        },
        body: jsonEncode(json),
      );

      Map noteJson = jsonDecode(response.body);

      date = DateTime.parse(noteJson["date"]);
    }
  }

  void deleteNote() async {
    await http.delete(
      "${globals.SERVER_ADDRESS}/note/noteRetrieveUpdateDestroy/$id",
      headers: {
        "Content-type": "application/json",
        "Authorization": globals.token
      },
    );
  }
}
