import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edgepos/constants.dart';

class UserApi {
  Future<Map<String, dynamic>> getUserByToken(String token) async {
    try {
      final response = await http.get(
        Uri.parse(Constants.userUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 404) {
        // User not found
        return {
          'success': false,
          'message': 'User not found',
        };
      } else {
        // Handle other error cases
        return {
          'success': false,
          'message': 'Error getting user',
        };
      }
    } catch (e) {
      // Handle exceptions
      return {
        'success': false,
        'message': 'Error getting user',
      };
    }
  }
}
