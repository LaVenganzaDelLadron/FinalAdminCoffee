import 'dart:convert';
import 'package:admincoffee/view/ipaddress/ip.dart';
import 'package:http/http.dart' as http;

class ApiCoffeeServices {
  static const String baseUrl = BASE_URL;

  static Future<Map<String, dynamic>> addCoffee(
      String name,
      String description,
      String category,
      double price,
      String aid,
      String image
      ) async {
    final url = Uri.parse('$baseUrl/coffee/add_coffee');
    var request = http.MultipartRequest('POST', url);

    request.fields['name'] = name;
    request.fields['description'] = description;
    request.fields['category'] = category;
    request.fields['price'] = price.toString();
    request.fields['aid'] = aid;
    request.files.add(await http.MultipartFile.fromPath('file', image));

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to add coffee. Status: ${response.statusCode}. Body: ${response.body}',
      );
    }

  }


  static Future<Map<String, dynamic>> deleteCoffee(String coffee_id) async {
    final url = Uri.parse('$baseUrl/coffee/deletecoffee/$coffee_id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to delete coffee: ${response.statusCode} ${response.body}');
    }
  }













}




