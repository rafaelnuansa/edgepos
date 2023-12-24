import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edgepos/constants.dart';

class CheckTokenApi {
  Future<Map<String, dynamic>> checkToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse(Constants.checkTokenUrl), // Menggunakan constant
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Token is valid, parse the response
        final Map<String, dynamic> data = json.decode(response.body);
        return {
          'success': true,
          'user': data['user'],
        };
      } else {
        // Token is invalid or expired
        return {
          'success': false,
          'message': 'Token is invalid or expired',
        };
      }
    } catch (e) {
      // Error occurred during the HTTP request
      return {
        'success': false,
        'message': 'Error occurred: $e',
      };
    }
  }
}
