import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  const TextForm({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          TextFormField(
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
              onPressed: () {},
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
