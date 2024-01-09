import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyGlobal {
  static Future<String?> getTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> getRefreshTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('refreshToken');
  }

  static Future<void> saveTokenToSharedPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  static Future<String> refreshToken() async {
    const String apiUrl = 'http://35.180.72.15/api/auth/refreshToken';

    String? refreshToken = await getRefreshTokenFromSharedPreferences();

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );
      final token = jsonDecode(response.body)['access_token'];
      saveTokenToSharedPreferences(token);
      return token;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static Future<String?> getDateTimeFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('timestamp');
  }
}
