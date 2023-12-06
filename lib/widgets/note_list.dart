import 'package:flutter/material.dart';

import '../helpers/setters.dart';
import '../models/note.dart';

typedef ItemClickCallback = void Function(bool);

// ignore: must_be_immutable
class NoteListView extends StatelessWidget {
  NoteListView({super.key, required this.onItemClicked});

  final List<Note> noteList = dummyNoteList;
  final ItemClickCallback onItemClicked;
  static bool listClicked = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          elevation: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(52, 52, 62, 1),
                  Color.fromRGBO(30, 30, 38, 1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
                title: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    noteList[index].date,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10.0,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    noteList[index].title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                onTap: () {
                  _handleItemClick(context, noteList[index].id);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleItemClick(BuildContext context, int? id) {
    NoteListView.listClicked = true;

    // Notify the parent widget about the item click
    onItemClicked(NoteListView.listClicked);
  }
}
