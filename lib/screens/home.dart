import 'package:flutter/material.dart';

import '../widgets/folder_form.dart';
import '../widgets/microphone_form.dart';
import '../widgets/visibility_form.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/image_form.dart';
import '../widgets/note_list.dart';
import '../widgets/text_form.dart';
import '../widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required String token,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNoteClicked = false;
  bool showForm = false;
  late int listId;

  void _showAction(BuildContext context, int index, int itemId) {
    late Widget form;
    switch (index) {
      case 0:
        form = TextForm(itemId: itemId);
        break;
      case 1:
        form = AudioRecorder(itemId: itemId);
        break;
      case 2:
        form = ImageForm(itemId: itemId);
        break;
      case 3:
        form = FolderForm(itemId: itemId);
        break;
      default:
        break;
    }
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF17171F),
          content: form,
        );
      },
    );
  }

  void _toggleFab() {
    setState(() {
      showForm = !showForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17171F),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MyAppBar(),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF17171F),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'Recent',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          VisiblityForm(isTextFieldVisible: showForm),
          const SizedBox(height: 4),
          Flexible(
            child: NoteListView(
              onItemClicked: (bool listClicked) {
                setState(() {
                  isNoteClicked = listClicked;
                });
              },
              onItemId: (int itemId) {
                setState(() {
                  listId = itemId;
                });
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isNoteClicked == true
          ? ExpandableFab(
              distance: 112,
              children: [
                ActionButton(
                  onPressed: () {
                    _showAction(context, 0, listId);
                  },
                  icon: Icons.text_fields,
                ),
                // ActionButton(
                //   onPressed: () {
                //     _showAction(context, 1, listId);
                //   },
                //   icon: Icons.keyboard_voice,
                // ),
                ActionButton(
                  onPressed: () {
                    _showAction(context, 2, listId);
                  },
                  icon: Icons.insert_photo,
                ),
                ActionButton(
                  onPressed: () {
                    _showAction(context, 3, listId);
                  },
                  icon: Icons.folder,
                ),
              ],
            )
          : FloatingActionButton(
              onPressed: () {
                _toggleFab();
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Ink(
                decoration: const ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(
                    colors: [Color(0xFF6163B1), Color(0xFF6F3D6D)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }
}
