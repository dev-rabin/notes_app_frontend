import 'dart:convert';
import 'dart:developer';

import '../../models/notes_models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = "http://192.168.1.4:5000/notes";

  static Future<void> addNote(Note note) async {
    Uri requesturi = Uri.parse("$_baseUrl/add");
    var response = await http.post(requesturi, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<void> deleteNote(Note note) async {
    Uri requestUri = Uri.parse("$_baseUrl/delete");
    var response = await http.post(requestUri, body: note.toMap());
    var decoded = jsonDecode(response.body);
    log(decoded.toString());
  }

  static Future<List<Note>> fetchedNotes(String userid) async {
    Uri requestUri = Uri.parse("$_baseUrl/list");
    var response = await http.post(requestUri, body: {"userid": userid});
    var decoded = jsonDecode(response.body);
    // log(decoded.toString());
    // return [];
    List<Note> notes = [];
    for (var NoteMap in decoded) {
      Note newNote = Note.fromMap(NoteMap);
      notes.add(newNote);
    }
    return notes;
  }
}
