import 'dart:convert';
import 'package:admincoffee/view/ipaddress/ip.dart';
import 'package:http/http.dart' as http;

import '../../model/category.dart';

class ApiCategoryServices {
  static const String baseUrl = BASE_URL;


  static Future<Map<String, dynamic>> addCategory(String name) async {
    final url = Uri.parse('$baseUrl/categories/addcategories/');
    var request = http.MultipartRequest('POST', url);
    request.fields['name'] = name;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to add category. Status: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }

  static Future<List<Category>> getCategories() async {
    final url = Uri.parse('$baseUrl/categories/getcategories/');
    final response = await http.post(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception(
        'Failed to load categories. Status: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }

  static Future<List<Category>> deleteCategory(String categoryId) async {
    final url = Uri.parse('$baseUrl/categories/deletecategories/$categoryId');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    }else {
      throw Exception(
        'Failed to load categories. Status: ${response.statusCode}. Body: ${response.body}',
      );
    }
  }





}
