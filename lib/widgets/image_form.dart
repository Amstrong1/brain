// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:brain/helpers/global.dart';
import 'package:brain/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ImageForm extends StatefulWidget {
  int itemId;
  ImageForm({super.key, required this.itemId});

  @override
  // ignore: library_private_types_in_public_api
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  final _formKey = GlobalKey<FormState>();
  File? image;

  Future<void> uploadImage() async {
    String apiUrl = 'http://35.180.72.15/api/items/newNote';
    String? authToken = await MyGlobal.getTokenFromSharedPreferences();
    String? tokenTime = await MyGlobal.getDateTimeFromSharedPreferences();

    DateTime date1 = DateTime.parse(tokenTime!);
    DateTime date2 = DateTime.now();

    Duration difference = date2.difference(date1);

    if (difference.inMinutes > 30 || difference.inMinutes == 0) {
      authToken = await MyGlobal.refreshToken();
    }
    if (_formKey.currentState!.validate()) {
      try {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

        if (image == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select an image')),
          );
          return;
        }

        request.headers['Content-Type'] = 'application/json';
        request.headers['Authorization'] = 'Bearer $authToken';

        request.fields['name'] = 'Image';
        request.fields['itemId'] = widget.itemId.toString();
        request.files.add(
          await http.MultipartFile.fromPath('content', image!.path),
        );

        var response = await request.send();

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Image uploaded successfully'),
            ),
          );
          _reloadApp();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to upload image'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during image upload: $e'),
          ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(colors: [
                Color(0xFF6163B1),
                Color(0xFF6F3D6D),
              ]),
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final img = await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  image = (img != null ? File(img.path) : null);
                });
              },
              label: const Text(
                'Choose Image',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(colors: [
                Color(0xFF6163B1),
                Color(0xFF6F3D6D),
              ]),
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final img = await picker.pickImage(source: ImageSource.camera);
                setState(() {
                  image = img != null ? File(img.path) : null;
                });
              },
              label: const Text(
                'Take Photo',
                style: TextStyle(color: Colors.white),
              ),
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
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
                uploadImage();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10.0),
          // Display the selected image
          if (image != null)
            CircleAvatar(
              radius: 50,
              backgroundImage: FileImage(image!),
            ),
        ],
      ),
    );
  }
}
