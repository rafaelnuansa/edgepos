import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edgepos/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardApi {
  Future<Map<String, dynamic>> getAllData() async {
    const String apiUrl = '${Constants.baseUrl}/dashboard-data';

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token not found');
      }

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      final http.Response response =
          await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to get dashboard data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
