import 'dart:convert';

import 'package:brain/helpers/global.dart';
import 'package:brain/screens/home.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class FolderForm extends StatefulWidget {
  const FolderForm({super.key, required int itemId});
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<FolderForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController itemController;

  @override
  void initState() {
    super.initState();
    itemController = TextEditingController();
  }

  void newItem() async {
    if (_formKey.currentState!.validate()) {
      String apiUrl = 'http://35.180.72.15/api/items/newItem';
      String? token = await MyGlobal.getTokenFromSharedPreferences();

      String? tokenTime = await MyGlobal.getDateTimeFromSharedPreferences();

      DateTime date1 = DateTime.parse(tokenTime!);
      DateTime date2 = DateTime.now();

      Duration difference = date2.difference(date1);

      if (difference.inMinutes > 30 || difference.inMinutes == 0) {
        token = await MyGlobal.refreshToken();
      }

      final Map<String, dynamic> requestData = {
        'name': itemController.text,
        'parent': 1,
      };

      if (token != null) {
        try {
          final http.Response response = await http.post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: jsonEncode(requestData),
          );

          if (response.statusCode == 200) {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item ajouté avec succès')),
            );
            _reloadApp();
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Erreur lors de l\'ajout')),
            );
          }
        } catch (error) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString())),
          );
        }
      } else {
        // Handle the case where the token is not available
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token not found in SharedPreferences')),
        );
      }
    }
  }

  void _reloadApp() async {
    String? token = await MyGlobal.getTokenFromSharedPreferences();

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
        height: 150,
        child: Column(
          children: [
            TextFormField(
              controller: itemController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter field name',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color.fromRGBO(30, 30, 38, 1),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                gradient: LinearGradient(colors: [
                  Color(0xFF6163B1),
                  Color(0xFF6F3D6D),
                ]),
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
                  newItem();
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
