import 'dart:convert';
import 'package:admincoffee/view/ipaddress/ip.dart';
import 'package:http/http.dart' as http;


class ApiStoreServices{
  static const String baseUrl = BASE_URL;

  static Future<Map<String, dynamic>> addStore(
      String name,
      String address,
      String prep_time_minutes,
      String status,
      ) async {
    final url = Uri.parse('$baseUrl/store/addstore/');
    var request = http.MultipartRequest('POST', url);

    request.fields["name"] = name;
    request.fields["address"] = address;
    request.fields["prep_time_minutes"] = prep_time_minutes;
    request.fields["status"] = status;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to add store. Status: ${response.statusCode}. Body: ${response.body}',
      );
    }

  }





}
