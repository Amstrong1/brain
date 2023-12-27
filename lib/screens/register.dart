import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/database.dart';
import 'home.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const RegistrationScreen({
    Key? key,
    required this.databaseHelper,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17171F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Image.asset(
                  'assets/icons/brain.png',
                  height: 100,
                  width: 100,
                ),
              ),

              const SizedBox(height: 10),

              // 2nd Row - Text
              const Text(
                'Welcome to Note Brain App,',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Create New Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 10),

              // 3rd Row - Text
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(
                        databaseHelper: widget.databaseHelper,
                      ),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: "You already have an account ? ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    children: [
                      TextSpan(
                        text: 'Click here',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF6F3D6D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 4th Row - Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color.fromRGBO(30, 30, 38, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color.fromRGBO(30, 30, 38, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value)) {
                          return 'Please enter valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color.fromRGBO(30, 30, 38, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                      obscureText: true,
                      controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              gradient: LinearGradient(colors: [
                                Color(0xFF6163B1),
                                Color(0xFF6F3D6D)
                              ]),
                            ),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              onPressed: () {
                                _submitForm(context);
                              },
                              child: const Text(
                                'SIGN UP',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const DividerWithText(),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF17171F),
                        padding: const EdgeInsets.all(20),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      icon: Image.asset(
                        'assets/icons/google.png',
                        width: 20,
                      ),
                      label: Text(
                        'Continue with Google'.toUpperCase(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse('http://35.180.72.15/api/auth/createUser');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, String> body = {
        'email': emailController.text,
        'username': nameController.text,
        'password': passwordController.text,
      };

      try {
        var response = await http.post(
          url,
          headers: headers,
          body: json.encode(body),
        );

        // if (response.statusCode == 200) {
        // If the server returns a 200 OK response, you can proceed with saving the user's credentials locally
        // var urlToken = Uri.parse('http://35.180.72.15/api/auth/login');
        // var responseLog = await http.post(
        //   urlToken,
        //   body: {
        //     'username': emailController.text,
        //     'password': passwordController.text,
        //   },
        // );

        // print('Response body: ${responseLog.body}');

        // if (response.statusCode == 200) {
        await widget.databaseHelper.saveUser(
          nameController.text,
          emailController.text,
          passwordController.text,
        );

        // Update isFirstLaunch to false after the first registration
        // await widget.databaseHelper.updateFirstLaunch(false);

        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                LoginScreen(databaseHelper: widget.databaseHelper),
          ),
        );
        // } else {
        //   print('Failed to get token: ${responseLog.reasonPhrase}');
        // }
        // } else {
        //   print('Failed to save user: ${response.body}');
        //   print('Response reason: ${response.reasonPhrase}');
        // }
      } catch (e) {
        if (kDebugMode) {
          print('Error encoding request body: $e');
        }
      }
    }
  }
}

class DividerWithText extends StatelessWidget {
  const DividerWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 2.0,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or Sign Up With ',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Expanded(
          child: Divider(
            color: Colors.grey,
            thickness: 2.0,
          ),
        ),
      ],
    );
  }
}
