import 'dart:convert';

import 'package:brain/helpers/global.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  var userInfo = UserInfo(
    email: '',
    username: '',
    id: '',
    plan: '',
  );
  // late TextEditingController nameController;
  // late TextEditingController emailController;
  // late TextEditingController passwordController;

  void fetchUserInfo() async {
    const String url = 'http://35.180.72.15/api/user/getInfo';

    String? authToken = await MyGlobal.getTokenFromSharedPreferences();
    String? tokenTime = await MyGlobal.getDateTimeFromSharedPreferences();

    DateTime date1 = DateTime.parse(tokenTime!);
    DateTime date2 = DateTime.now();

    Duration difference = date2.difference(date1);

    if (difference.inMinutes > 30 || difference.inMinutes == 0) {
      authToken = await MyGlobal.refreshToken();
    }

    final Map<String, String> headers = {'Authorization': 'Bearer $authToken'};

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        userInfo = UserInfo.fromJson(jsonDecode(response.body));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request failed')),
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF17171F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF17171F),
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 12,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Brain Search',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
        ],
      ),
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
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color.fromRGBO(30, 30, 38, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                      controller:
                          TextEditingController(text: userInfo.username),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color.fromRGBO(30, 30, 38, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                      controller: TextEditingController(text: userInfo.email),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      readOnly: true,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Plan',
                        labelStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: const Color.fromRGBO(30, 30, 38, 1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        contentPadding: const EdgeInsets.all(20.0),
                      ),
                      controller: TextEditingController(text: userInfo.plan),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserInfo {
  final String email;
  final String username;
  final String id;
  final String plan;

  UserInfo({
    required this.email,
    required this.username,
    required this.id,
    required this.plan,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      email: json['email'] as String,
      username: json['username'] as String,
      id: json['id'] as String,
      plan: json['plan'] as String,
    );
  }
}
