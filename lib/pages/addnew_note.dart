// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/models/notes_models.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddNewNotePage extends StatefulWidget {
  final bool isupdate;
  final Note? note;
  const AddNewNotePage({
    super.key,
    required this.isupdate,
    this.note,
  });

  @override
  State<AddNewNotePage> createState() => _AddNewNotePageState();
}

class _AddNewNotePageState extends State<AddNewNotePage> {
  FocusNode noteFocus = FocusNode();

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  void addNewNote() {
    Note newNote = Note(
        id: Uuid().v1(),
        userid: "robinmandhotia",
        title: titleController.text,
        content: contentController.text,
        dateadded: DateTime.now());

    Provider.of<NotesProvider>(context, listen: false).addNote(newNote);
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    if (widget.isupdate == true) {
      titleController.text = widget.note!.title!;
      contentController.text = widget.note!.content!;
    }
  }

  void updateNote() {
    widget.note!.title = titleController.text;
    widget.note!.content = contentController.text;
    widget.note!.dateadded = DateTime.now();
    Provider.of<NotesProvider>(context, listen: false).updateNote(widget.note!);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    if (widget.isupdate) {
                      updateNote();
                    } else {
                      addNewNote();
                    }
                  },
                  icon: Icon(CupertinoIcons.check_mark))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  onSubmitted: (value) {
                    if (value != "") {
                      noteFocus.requestFocus();
                    }
                  },
                  autofocus: (widget.isupdate == true) ? false : true,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      hintText: "Title", border: InputBorder.none),
                ),
                Expanded(
                  child: TextField(
                    controller: contentController,
                    focusNode: noteFocus,
                    style: TextStyle(fontSize: 18),
                    decoration: InputDecoration(
                        hintText: "Write A Note", border: InputBorder.none),
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
