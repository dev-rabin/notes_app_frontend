// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/providers/notes_provider.dart';
import 'package:provider/provider.dart';
import '../models/notes_models.dart';
import 'addnew_note.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String searchQuerry = '';
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);
    return Material(
        child: Scaffold(
      appBar: AppBar(
        title: Text("NotesApp"),
        centerTitle: true,
      ),
      body: (notesProvider.isLoading == false)
          ? SafeArea(
              child: (notesProvider.notes.isNotEmpty)
                  ? ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextField(
                            onChanged: (val) {
                              setState(() {
                                searchQuerry = val;
                              });
                            },
                            decoration: InputDecoration(hintText: "Search"),
                          ),
                        ),
                        (notesProvider.getSearchData(searchQuerry).isNotEmpty)
                            ? GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemCount: notesProvider
                                    .getSearchData(searchQuerry)
                                    .length,
                                itemBuilder: (context, index) {
                                  //Index of Note
                                  Note currentNote = notesProvider
                                      .getSearchData(searchQuerry)[index];
                                  return GestureDetector(
                                    onTap: () {
                                      // Update
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: ((context) =>
                                                  AddNewNotePage(
                                                    isupdate: true,
                                                    note: currentNote,
                                                  ))));
                                    },
                                    onLongPress: () {
                                      //Delete
                                      notesProvider.deleteNote(currentNote);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color: Colors.grey, width: 2),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentNote.title!,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              currentNote.content!,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Color.fromARGB(
                                                      255, 118, 118, 118)),
                                              maxLines: 6,
                                              overflow: TextOverflow.ellipsis,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("No Notes Found"),
                                ),
                              ),
                      ],
                    )
                  : Center(
                      child: Text('No Notes Yet'),
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (context) => AddNewNotePage(
                        isupdate: false,
                      ),
                  fullscreenDialog: true));
        },
        child: Icon(Icons.add),
      ),
    ));
  }
}
