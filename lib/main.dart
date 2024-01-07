import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/login.dart';
import 'screens/home.dart';

// -*- coding: utf-8 -*-

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Future<String?> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getDateTimeFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('timestamp');
  }

  String? authToken = await getTokenFromSharedPreferences();
  String? tokenTime = await getDateTimeFromSharedPreferences();
  DateTime date1;
  if (tokenTime != null) {
    date1 = DateTime.parse(tokenTime);
  } else {
    date1 = DateTime.now();
  }
  DateTime date2 = DateTime.now();

  Duration difference = date2.difference(date1);

  runApp(MyApp(
    authToken: authToken,
    difference: difference,
  ));
}

class MyApp extends StatelessWidget {
  final Duration difference;
  final String? authToken;

  const MyApp({
    Key? key,
    required this.authToken,
    required this.difference,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: difference.inMinutes < 30 && difference.inMinutes > 0
          ? HomePage(token: authToken!)
          : const LoginScreen(),
      // home: LoginScreen(databaseHelper: databaseHelper),
    );
  }
}
