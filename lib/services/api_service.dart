import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neighbourhood/models/product.dart';
import 'package:neighbourhood/models/service.dart';
import 'package:neighbourhood/constants.dart';

class ApiService {
  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<List<Service>> fetchServices() async {
    final response = await http.get(Uri.parse('$baseUrl/services'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => Service.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }
}
