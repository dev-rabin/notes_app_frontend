import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_models.dart';
import 'package:notes_app/services/services/api.dart';

class NotesProvider with ChangeNotifier {
  List<Note> notes = [];
  bool isLoading = true;
  NotesProvider() {
    fetchNotes();
  }

  List<Note> getSearchData(String searchQuerry) {
    return notes
        .where((element) =>
            element.title!.toLowerCase().contains(searchQuerry.toLowerCase()) ||
            element.title!.toLowerCase().contains(searchQuerry.toLowerCase()))
        .toList();
  }

  void sortNotes() {
    notes.sort(((a, b) => b.dateadded!.compareTo(a.dateadded!)));
  }

  void addNote(Note note) {
    notes.add(note);
    sortNotes();
    notifyListeners();
    ApiService.addNote(note);
  }

  void updateNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes[indexOfNote] = note;
    sortNotes();
    notifyListeners();
  }

  void deleteNote(Note note) {
    int indexOfNote =
        notes.indexOf(notes.firstWhere((element) => element.id == note.id));
    notes.removeAt(indexOfNote);
    sortNotes();
    notifyListeners();
    ApiService.deleteNote(note);
  }

  void fetchNotes() async {
    notes = await ApiService.fetchedNotes("robinmandhotia");
    isLoading = false;
    sortNotes();
    notifyListeners();
  }
}
