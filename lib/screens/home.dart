import 'package:flutter/material.dart';

import '../widgets/folder_form.dart';
import '../widgets/microphone_form.dart';
import '../widgets/visibility_form.dart';
import '../widgets/expandable_fab.dart';
import '../widgets/image_form.dart';
import '../widgets/note_list.dart';
import '../widgets/text_form.dart';
import '../helpers/database.dart';
import '../widgets/app_bar.dart';

class HomePage extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const HomePage({
    Key? key,
    required this.databaseHelper, required String token,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isNoteClicked = false;

  void _showAction(BuildContext context, int index) {
    late Widget form;
    switch (index) {
      case 0:
        form = const TextForm();
        break;
      case 1:
        form = const AudioRecorder();
        break;
      case 2:
        form = const ImageForm();
        break;
      case 3:
        form = const FolderForm();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17171F),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyAppBar(databaseHelper: widget.databaseHelper),
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
          const VisiblityForm(isTextFieldVisible: false),
          Flexible(
            child: NoteListView(
              onItemClicked: (bool listClicked) {
                isNoteClicked = listClicked;
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.text_fields),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.keyboard_voice),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 3),
            icon: const Icon(Icons.folder),
          ),
        ],
      ),
    );
  }
}
