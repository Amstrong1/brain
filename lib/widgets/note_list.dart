import 'package:flutter/material.dart';
import '../helpers/setters.dart';
import '../models/note.dart';

typedef ItemClickCallback = void Function(bool);

class NoteListView extends StatefulWidget {
  final ItemClickCallback onItemClicked;

  const NoteListView({Key? key, required this.onItemClicked}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  List<Note> noteList = dummyNoteList;
  bool listClicked = false;

  Map<int, bool> iconVisibilityMap = {};

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index) {
        return buildNoteItem(noteList[index]);
      },
    );
  }

  Widget buildNoteItem(Note note) {
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
          child: Stack(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                title: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        note.date,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _handleItemClick(context, note.id);
                },
              ),
              Positioned(
                top: 0,
                right: 3,
                child: IconButton(
                  onPressed: () {
                    _toggleIconVisibility(note.id);
                  },
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ),
              if (iconVisibilityMap[note.id] ?? false)
                Positioned(
                  top: 0,
                  right: 35,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.playlist_add_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit_note_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleItemClick(BuildContext context, int? id) {
    setState(() {
      listClicked = true;
    });

    // Notify the parent widget about the item click
    widget.onItemClicked(listClicked);
  }

  void _toggleIconVisibility(int noteId) {
    setState(() {
      iconVisibilityMap[noteId] = !(iconVisibilityMap[noteId] ?? false);
    });
  }
}
