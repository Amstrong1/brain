import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'helpers/database.dart';
import 'screens/login.dart';
import 'screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final databaseHelper = DatabaseHelper();
  await databaseHelper.initializeDatabase();

  bool isFirstLaunch = await databaseHelper.checkFirstLaunch();

  runApp(MyApp(isFirstLaunch: isFirstLaunch, databaseHelper: databaseHelper));
}

class MyApp extends StatelessWidget {
  final bool isFirstLaunch;
  final DatabaseHelper databaseHelper;

  const MyApp({
    Key? key,
    required this.isFirstLaunch,
    required this.databaseHelper,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      // debugShowCheckedModeBanner: false,
      home: isFirstLaunch
          ? LoginScreen(databaseHelper: databaseHelper)
          : HomePage(databaseHelper: databaseHelper),
    );
  }
}
