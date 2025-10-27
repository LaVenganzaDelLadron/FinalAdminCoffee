import 'dart:convert';
import 'package:admincoffee/view/ipaddress/ip.dart';
import 'package:http/http.dart' as http;

class ApiOrderServices {
  static const String baseUrl = BASE_URL;

  static Future<Map<String, dynamic>> orderCount() async {
    final url = Uri.parse('$baseUrl/order/ordercount/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch product count: ${response.statusCode} ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getAllOrders() async {
    final url = Uri.parse('$baseUrl/order/getorders/');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return {"orders": data};
      } else {
        return {"error": "Failed to load orders: ${response.body}"};
      }
    } catch (e, stack) {
      return {"error": e.toString()};
    }
  }

  static Future<List<dynamic>> getStatusOrders(String status) async {
    final url = Uri.parse('$baseUrl/getstatusorders/$status');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception(
        'Failed to fetch status orders: ${response.statusCode} ${response.body}',
      );
    }
  }

  static Future<Map<String, dynamic>> deleteOrder(String id) async {
    final url = Uri.parse('$baseUrl/order/deleteorder/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to delete coffee: ${response.statusCode} ${response.body}');
    }
  }

}