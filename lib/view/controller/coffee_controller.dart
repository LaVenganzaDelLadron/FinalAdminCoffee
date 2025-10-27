import 'dart:io';
import 'package:get/get.dart';
import '../../model/coffee.dart';
import '../services/api_coffee_services.dart';

class CoffeeController extends GetxController {

  var coffeeList = <Coffee>[].obs;
  var isLoading = false.obs;



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

  Future<void> fetchAllCoffees(String aid) async {
    try {
      isLoading(true);
      final result = await ApiCoffeeServices.getAllCoffees(aid);

      final data = result["data"]?["coffees"] ?? result["coffees"];

      if (data is List) {
        coffeeList.assignAll(
          data.map((e) => Coffee.fromJson(e as Map<String, dynamic>)).toList(),
        );
      } else {
        coffeeList.clear();
      }
    } catch (e, st) {
      print("❌ Error fetching coffees: $e\n$st");
    } finally {
      isLoading(false);
    }
  }

}