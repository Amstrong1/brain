import 'package:brain/screens/home.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

typedef ItemClickCallback = void Function(bool);
typedef ItemIdCallback = void Function(int);

class NoteListView extends StatefulWidget {
  final ItemClickCallback onItemClicked;
  final ItemIdCallback onItemId;

  const NoteListView(
      {Key? key, required this.onItemClicked, required this.onItemId})
      : super(key: key);

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

  void _reloadApp() async {
    String? token = await _getTokenFromSharedPreferences();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage(token: token!)),
        (Route<dynamic> route) => false,
      );
    });
  }

  Future<String?> _getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> _getDateTimeFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('timestamp');
  }

  Future<String?> _getRefreshTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  Future<void> _saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<String> refreshToken() async {
    const String apiUrl = 'http://35.180.72.15/api/auth/refreshToken';

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
      _saveTokenToSharedPreferences(token);
      return token;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> getAllItems() async {
    String getItems = 'http://35.180.72.15/api/items/getAllItems';

    String? authToken = await _getTokenFromSharedPreferences();
    String? tokenTime = await _getDateTimeFromSharedPreferences();

    DateTime date1 = DateTime.parse(tokenTime!);
    DateTime date2 = DateTime.now();

    Duration difference = date2.difference(date1);

    if (difference.inMinutes > 30 || difference.inMinutes == 0) {
      authToken = await refreshToken();
    }

    try {
      final response = await http.get(
        Uri.parse(getItems),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

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
                'notes': childrenData[i]['notes'],
              });
            }
          }
        }

        setState(() {
          // Update the state with the new data
          noteList = noteList.reversed.toList();
          _dataLoaded = true;
        });
        return noteList;
      } else {
        const SnackBar(content: Text('No data fetched'));
        throw Exception('No data fetched');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteItem(String itemId) async {
    String delItem = 'http://35.180.72.15/api/items/deleteItem';

    String? authToken = await _getTokenFromSharedPreferences();
    String? tokenTime = await _getDateTimeFromSharedPreferences();

    DateTime date1 = DateTime.parse(tokenTime!);
    DateTime date2 = DateTime.now();

    Duration difference = date2.difference(date1);

    if (difference.inMinutes > 30 || difference.inMinutes == 0) {
      authToken = await refreshToken();
    }

    final Map<String, String> body = {
      'id': itemId,
    };

    try {
      final response = await http.delete(
        Uri.parse(delItem),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item Supprimé'),
            duration: Duration(seconds: 2),
          ),
        );
        _reloadApp();
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Echec de la suppression'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Une erreur s'est produite lors de la requête.
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la requête DELETE : $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  bool listClicked = false;
  late int itemId;
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
                    children: <Widget>[
                      for (var subnote in note['notes'])
                        ListTile(
                          title: Text(
                            subnote['name'],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          subtitle: Text(
                            subnote['content'],
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
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
                            onPressed: () {
                              _handleItemClick(context, note['id']);
                            },
                            icon: const Icon(
                              Icons.check_box_outlined,
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
                            onPressed: () {
                              deleteItem(note['id'].toString());
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
        const SizedBox(height: 15),
      ],
    );
  }

  void _handleItemClick(BuildContext context, int? id) {
    setState(() {
      itemId = id!;
      listClicked = !listClicked;
      if (_clickedNoteId != id) {
        _clickedNoteId = id;
      } else {
        _clickedNoteId = -1;
      }
    });

    // Notify the parent widget about the item click
    widget.onItemClicked(listClicked);
    widget.onItemId(itemId);
  }

  void _toggleIconVisibility(int noteId) {
    setState(() {
      iconVisibilityMap[noteId] = !(iconVisibilityMap[noteId] ?? false);
    });
  }
}
