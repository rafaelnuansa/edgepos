import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:edgepos/constants.dart';
import 'package:edgepos/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryApi {
  final String apiUrl = Constants.categoriesUrl;

  Future<List<Category>> getCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token') ?? '';


    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      List<Category> categories = data.map((categoryData) {
        return Category.fromJson(categoryData);
      }).toList();

      return categories;
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
