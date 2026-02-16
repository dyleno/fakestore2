import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';
  static const String _boxName = 'productsBox';

  Future<List<Product>> getProducts({String? category}) async {
    final box = Hive.box<Product>(_boxName);

    try {
      final url = category != null && category != 'Alle'
          ? '$_baseUrl/products/category/$category'
          : '$_baseUrl/products';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        List<Product> products =
            jsonResponse.map((data) => Product.fromJson(data)).toList();

        // Only clear and update cache for "All" products to avoid partial cache issues
        if (category == null || category == 'Alle') {
          await box.clear();
          for (var product in products) {
            await box.put(product.id, product);
          }
        }

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      if (box.isNotEmpty) {
        final products = box.values.toList();
        if (category != null && category != 'Alle') {
          return products.where((p) => p.category == category).toList();
        }
        return products;
      }
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/products/categories'));
      if (response.statusCode == 200) {
        return List<String>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      return [];
    }
  }
}
