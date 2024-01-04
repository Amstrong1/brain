import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/database.dart';
import 'register.dart';
import 'home.dart';

class LoginScreen extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const LoginScreen({
    Key? key,
    required this.databaseHelper,
  }) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<String> _getToken() async {
    var url = Uri.parse('http://35.180.72.15/api/auth/login');
    try {
      var result = await http.post(
        url,
        body: {
          'username': emailController.text,
          'password': passwordController.text,
        },
      );
      final token = jsonDecode(result.body)['access_token'];
      final refreshToken = jsonDecode(result.body)['refresh_token'];
      await _saveTokenToSharedPreferences(token);
      await _saveRefreshTokenToSharedPreferences(refreshToken);
      return token;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> _saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  Future<void> _saveRefreshTokenToSharedPreferences(String refreshToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('refreshToken', refreshToken);
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
              const Text(
                'Welcome to Note Brain App,',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Sign In to your Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegistrationScreen(
                        databaseHelper: widget.databaseHelper,
                      ),
                    ),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: "You don't have an account ? ",
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
              Form(
                key: _formKey,
                child: Column(
                  children: [
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
                      controller: passwordController,
                      obscureText: true,
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
                                Color(0xFF6F3D6D),
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
                                'SIGN IN',
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
              // google login form 
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
      // Update isFirstLaunch to false after the first registration
      // await widget.databaseHelper.updateFirstLaunch(false);

      try {
        final token = await _getToken();
        // Redirect to the home screen with the token
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomePage(databaseHelper: widget.databaseHelper, token: token),
          ),
        );
      } catch (e) {
        SnackBar(content: Text(e.toString()));
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
            'Or Sign In With ',
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
