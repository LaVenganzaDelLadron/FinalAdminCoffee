import 'dart:convert';
import 'package:admincoffee/view/ipaddress/ip.dart';
import 'package:http/http.dart' as http;




class ApiMoneyServices {
  static const String baseUrl = BASE_URL;

  static Future<Map<String, dynamic>> getMoneyData() async {
    final url = Uri.parse('$baseUrl/money/totalrevenue/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch money data: ${response.statusCode} ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getPendingMoneyData() async {
    final url = Uri.parse('$baseUrl/money/pendingpayments/');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to fetch other money data: ${response.statusCode} ${response.body}');
    }
  }


}
