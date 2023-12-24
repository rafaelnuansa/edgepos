import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edgepos/constants.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  Future<Map<String, dynamic>> login(String email, String password) async {
    const String apiUrl = Constants.loginUrl;

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'email': email,
      'password': password,
    };

    try {
      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Save the token to local storage
        await saveTokenToLocalStorage(responseData['token']);

        // Simpan token dan informasi pengguna ke local storage
        // print(responseData.toString());
        await saveUserDataToLocalStorage(responseData);
        return responseData;
      } else {
        throw Exception('Failed to login');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> saveTokenToLocalStorage(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<void> saveUserDataToLocalStorage(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(userData['user']));
  }

  // Function to get the stored token
  static Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<bool> checkToken() async {
    final String token = await getToken();

    if (token.isEmpty) {
      return false;
    }

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final http.Response response = await http.get(
        Uri.parse(Constants.checkTokenUrl),
        headers: headers,
      );

      return response.statusCode == 200;
    } catch (error) {
      // Handle errors (e.g., network error, server error)
      return false;
    }
  }

  // Function to check if the token exists in local storage and is valid
  static Future<bool> hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool hasLocalToken = prefs.containsKey('token');

    if (!hasLocalToken) {
      return false;
    }

    // Check if the stored token is still valid by making a request to the server
    return await checkToken();
  }

   static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Remove the token
    await prefs.remove('token');
    // Remove the user data
    await prefs.remove('user');
  }
  
}
