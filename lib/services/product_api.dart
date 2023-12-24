import 'dart:convert';
import 'package:edgepos/models/product_model.dart';
import 'package:http/http.dart' as http;
import 'package:edgepos/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductApi {
  final String apiUrl = Constants.productsUrl;

  Future<List<Product>> getProducts() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success']) {
          final List<Product> products = List.from(data['data']
              .map((productData) => Product.fromJson(productData)));
          return products;
        } else {
          throw Exception('Failed to load products: ${data['error']}');
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}
