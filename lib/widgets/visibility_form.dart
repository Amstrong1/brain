import 'package:flutter/material.dart';


class VisiblityForm extends StatelessWidget {
  const VisiblityForm({super.key, required this.isTextFieldVisible});

  final bool isTextFieldVisible;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isTextFieldVisible,
      child: 
      Container(
        margin: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        padding: const EdgeInsets.all(25),
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
        child: TextFormField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter your text',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color.fromRGBO(30, 30, 38, 1),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ),
    );
  }
}
