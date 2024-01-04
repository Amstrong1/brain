import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef ItemClickCallback = void Function(bool);

class NoteListView extends StatefulWidget {
  final ItemClickCallback onItemClicked;

  const NoteListView({Key? key, required this.onItemClicked}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  List<Map<String, dynamic>> noteList = [];

  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    if (!_dataLoaded) {
      getAllItems();
    }
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getRefreshTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<String> refreshToken() async {
    const String apiUrl = 'http://127.0.0.1:8000/0.1.0/api/auth/refreshToken';

    String? refreshToken = await _getRefreshTokenFromSharedPreferences();

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );
      final token = jsonDecode(response.body)['access_token'];
      return token;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  String getItems = 'http://35.180.72.15/api/items/getAllItems';

  String delItem = 'http://35.180.72.15/api/items/deleteItem';

  Future<List<Map<String, dynamic>>> getAllItems() async {
    String? authToken = await _getTokenFromSharedPreferences();
    authToken ??= await refreshToken();
    try {
      final response = await http.get(
        Uri.parse(getItems),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      print(authToken);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('root')) {
          Map<String, dynamic> rootData = responseData['root'];
          if (rootData.containsKey('children')) {
            List<dynamic> childrenData = rootData['children'];
            for (var i = 0; i < childrenData.length; i++) {
              noteList.add({
                'id': childrenData[i]['id'],
                'name': childrenData[i]['name'],
              });
            }
          }
        }

        setState(() {
          // Update the state with the new data
          noteList = noteList;
          _dataLoaded = true;
        });
        return noteList;
      } else {
        throw Exception('No data fetched');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteItem() async {
    String? authToken = await _getTokenFromSharedPreferences();
    authToken ??= await refreshToken();

    try {
      final response = await http.delete(
        Uri.parse(delItem),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        // La suppression a réussi.
        print('Item supprimé avec succès');
      } else {
        // La suppression a échoué.
        print('Échec de la suppression : ${response.statusCode}');
      }
    } catch (e) {
      // Une erreur s'est produite lors de la requête.
      print('Erreur lors de la requête DELETE : $e');
    }
  }

  bool listClicked = false;
  int _clickedNoteId = -1;

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

  Widget buildNoteItem(Map<String, dynamic> note) {
    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                if (note['id'] == _clickedNoteId)
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
              ],
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
                  // GestureDetector(
                  //   onTap: () {
                  //     _handleItemClick(context, note['id']);
                  //   },
                  // ),
                  ExpansionTile(
                    trailing: const SizedBox(width: 0, height: 0),
                    title: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        note['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    children: const <Widget>[
                      ListTile(
                        leading: Icon(Icons.text_fields),
                        title: Text(
                          'Contenu texte',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ListTile(
                  //   contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                  //   title: Padding(
                  //     padding: const EdgeInsets.all(8),
                  //     child: Text(
                  //       note['name'],
                  //       style: const TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 18.0,
                  //       ),
                  //     ),
                  //   ),
                  //   subtitle: Padding(
                  //     padding: const EdgeInsets.all(8),
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.end,
                  //       children: [
                  //         Text(
                  //           note['name'],
                  //           style: const TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 10.0,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  //   onTap: () {
                  //     _handleItemClick(context, note['id']);
                  //   },
                  // ),
                  Positioned(
                    top: 0,
                    right: 3,
                    child: IconButton(
                      onPressed: () {
                        _toggleIconVisibility(note['id']);
                      },
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (iconVisibilityMap[note['id']] ?? false)
                    Positioned(
                      top: 0,
                      right: 35,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit_note_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteItem();
                            },
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
        ),
      ],
    );
  }

  void _handleItemClick(BuildContext context, int? id) {
    setState(() {
      listClicked = !listClicked;
      _clickedNoteId = id!;
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
