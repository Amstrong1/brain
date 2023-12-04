import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/user.dart';

class DatabaseHelper {
  late Database _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'user_database.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, email TEXT UNIQUE, password TEXT, createdAt INTEGER)',
    );

    await db.execute(
      'CREATE TABLE first_launch(id INTEGER PRIMARY KEY AUTOINCREMENT, isFirstLaunch INTEGER)',
    );

    await db.insert(
      'first_launch',
      {'isFirstLaunch': 1},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<bool> checkFirstLaunch() async {
    List<Map<String, dynamic>> result = await _database.query('first_launch');
    int isFirstLaunch = result.isNotEmpty ? result[0]['isFirstLaunch'] : 1;
    return isFirstLaunch == 1;
  }

  Future<void> updateFirstLaunch(bool value) async {
    await _database.update(
      'first_launch',
      {'isFirstLaunch': value ? 1 : 0},
    );
  }

  Future<void> saveUser(String name, String email, String password) async {
    final user = User(
      name: name,
      email: email,
      password: password,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _database.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsers() async {
    final List<Map<String, dynamic>> maps = await _database.query('users');
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i]['id'],
        name: maps[i]['name'],
        email: maps[i]['email'],
        password: maps[i]['password'],
        createdAt: maps[i]['createdAt'],
      );
    });
  }
}
