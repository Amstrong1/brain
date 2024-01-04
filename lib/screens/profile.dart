import 'package:flutter/material.dart';
import 'package:brain/models/user.dart';

import '../helpers/database.dart';

class ProfileScreen extends StatefulWidget {
  final DatabaseHelper databaseHelper;

  const ProfileScreen({
    Key? key,
    required this.databaseHelper,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  // late TextEditingController nameController;
  // late TextEditingController emailController;
  // late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    // nameController = TextEditingController();
    // emailController = TextEditingController();
    // passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17171F),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<User>>(
            // Fetch the user data using the DatabaseHelper
            future: widget.databaseHelper.getUsers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Loading indicator while fetching data
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                // If user data is available, display it in the TextFormFields
                final users = snapshot.data!;
                final user = users.isNotEmpty
                    ? users[0]
                    : null; // Assuming only one user for simplicity

                return Column(
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
                      'My Note Brain App Profile',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
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
                            controller:
                                TextEditingController(text: user?.name ?? ''),
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
                            controller:
                                TextEditingController(text: user?.email ?? ''),
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
                            controller: TextEditingController(
                                text: user?.password ?? ''),
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
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      'UPDATE',
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
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
