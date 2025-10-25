import 'dart:io';
import 'package:get/get.dart';
import '../services/api_coffee_services.dart';

class CoffeeController extends GetxController {

  Future<void> AddCoffee(
      String name,
      String description,
      double price,
      String category,
      String aid,
      File image,
      ) async {
    try {
      final result = await ApiCoffeeServices.addCoffee(
        name,
        description,
        category,
        price,
        aid,
        image.path,
      );

      if (result["coffee_id"] != null) {
        print("Coffee added successfully: ${result["coffee_id"]}");
      }else {
        print("Failed to add coffee: ${result["error"]}");
      }
    }catch(e, stack){
      print(e);
    }
  }

  Future<int> fetchCoffeeCount(String aid) async {
    try {
      final result = await ApiCoffeeServices.coffeeCount(aid);

      if (result["count"] != null) {
        int count = result["count"];
        return count;
      } else {
        return 0;
      }
    } catch (e, stack) {
      return 0;
    }
  }


}









