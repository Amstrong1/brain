import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:brain/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class TextForm extends StatefulWidget {
  int itemId;

  TextForm({super.key, required this.itemId});
  @override
  // ignore: library_private_types_in_public_api
  _TextFormState createState() => _TextFormState();
}

class _TextFormState extends State<TextForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    contentController = TextEditingController();
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

  Future<void> createNewNote() async {
    String apiUrl = 'http://35.180.72.15/api/items/newNote';
    String? authToken = await _getTokenFromSharedPreferences();
    String? tokenTime = await _getDateTimeFromSharedPreferences();

    DateTime date1 = DateTime.parse(tokenTime!);
    DateTime date2 = DateTime.now();

    Duration difference = date2.difference(date1);

    if (difference.inMinutes > 30 || difference.inMinutes == 0) {
      authToken = await refreshToken();
    }
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $authToken',
          },
          body: {
            'name': nameController.text,
            'itemId': widget.itemId.toString(),
            'content': contentController.text,
          },
        );

        if (response.statusCode == 200) {
          // Traitement réussi
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note créée avec succès')),
          );
          _reloadApp();
        } else {
          // Gérer les erreurs
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Échec de la création de la note'),
            ),
          );
        }
      } catch (e) {
        // Gérer les exceptions
        if (kDebugMode) {
          print('Erreur lors de la requête POST : $e');
        }
      }
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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SizedBox(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter note name',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(30, 30, 38, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextFormField(
              controller: contentController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: const TextStyle(color: Colors.white),
              maxLines: null,
              minLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter text',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                filled: true,
                fillColor: const Color.fromRGBO(30, 30, 38, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6163B1),
                    Color(0xFF6F3D6D),
                  ],
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  createNewNote();
                },
                child: const Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
