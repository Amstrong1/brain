import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/database.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper();
  await databaseHelper.initializeDatabase();

  Future<String?> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  String? authToken = await getTokenFromSharedPreferences();

  // bool isFirstLaunch = await databaseHelper.checkFirstLaunch();

  runApp(MyApp(
    // isFirstLaunch: isFirstLaunch,
    databaseHelper: databaseHelper, authToken: authToken,
  ));
}

class MyApp extends StatelessWidget {
  // final bool isFirstLaunch;
  final DatabaseHelper databaseHelper;
  final String? authToken;

  const MyApp({
    Key? key,
    // required this.isFirstLaunch,
    required this.databaseHelper,
    required this.authToken,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: authToken != null
          ? HomePage(
              databaseHelper: databaseHelper,
              token: authToken!,
            )
          : LoginScreen(databaseHelper: databaseHelper),
      // home: LoginScreen(databaseHelper: databaseHelper),
    );
  }
}
