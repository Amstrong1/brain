import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageForm extends StatefulWidget {
  const ImageForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageFormState createState() => _ImageFormState();
}

class _ImageFormState extends State<ImageForm> {
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                image = img;
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
                image = img;
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
      ],
    );
  }
}
