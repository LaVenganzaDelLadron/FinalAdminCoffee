import 'dart:io';
import 'package:get/get.dart';
import '../../model/coffee.dart';
import '../services/api_category_services.dart';
import '../services/api_coffee_services.dart';

class CoffeeController extends GetxController {
  // 🔹 Reactive variables
  var coffeeList = <Coffee>[].obs;
  var categories = <String>[].obs;
  var selectedCategory = 'All'.obs;
  var isLoading = false.obs;
  var coffeeCount = 0.obs;
  final filteredCoffeeList = <Coffee>[].obs;


  Future<void> addCoffee(
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
        print("☕ Coffee Added Successfully: ${result["coffee_id"]}");

        // 👇 Immediately update the count and list
        await fetchAllCoffees(aid);
        coffeeCount.value = coffeeList.length;
      } else {
        print("⚠️ AddCoffee response missing coffee_id.");
      }
    } catch (e, stack) {
      print("🔥 [ERROR] AddCoffee failed: $e\n$stack");
    }
  }

  Future<void> updateCoffee(
      String coffee_id,
      String name,
      String description,
      double price,
      String category,
      String aid,
      File image,
      ) async {
    try {
      final result = await ApiCoffeeServices.updateCoffee(
        coffee_id,
        name,
        description,
        category,
        price,
        aid,
        image.path,
      );

      print("☕ Coffee Updated: ${result["coffee_id"]}");
      await fetchAllCoffees(aid); // refresh list
      coffeeCount.value = coffeeList.length;
    } catch (e, stack) {
      print("🔥 [ERROR] UpdateCoffee failed: $e\n$stack");
    }
  }


  Future<int> fetchCoffeeCount(String aid) async {
    try {
      final result = await ApiCoffeeServices.coffeeCount(aid);
      if (result["count"] != null) {
        coffeeCount.value = result["count"]; // 👈 sync live count
        return result["count"];
      } else {
        coffeeCount.value = 0;
        return 0;
      }
    } catch (e, stack) {
      print("⚠️ Coffee count fetch failed: $e");
      coffeeCount.value = 0;
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
        coffeeCount.value = coffeeList.length; // 👈 auto update count
        print("✅ Coffee list updated. Total: ${coffeeList.length}");
      } else {
        coffeeList.clear();
        coffeeCount.value = 0;
      }
    } catch (e, st) {
      print("❌ fetchAllCoffees failed: $e");
      coffeeList.clear();
      coffeeCount.value = 0;
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final result = await ApiCategoryServices.getCategories();
      categories.value = ['All', ...result.map((e) => e.name).toList()];
    } catch (e) {
      categories.value = ['All'];
    }
  }

  Future<void> fetchCoffees(String aid) async {
    try {
      isLoading(true);

      if (selectedCategory.value == 'All') {
        final result = await ApiCoffeeServices.getAllCoffees(aid);
        final data = result["coffees"];

        if (data is List) {
          coffeeList.assignAll(
            data.map((e) => Coffee.fromJson(e as Map<String, dynamic>)).toList(),
          );
          coffeeCount.value = coffeeList.length; // 👈 keep count updated
          print("✅ Coffee list updated (All). Total: ${coffeeList.length}");
        } else {
          coffeeList.clear();
          coffeeCount.value = 0;
        }
      } else {
        final data = await ApiCoffeeServices.fetchCoffeesByCategory(
          int.parse(aid),
          selectedCategory.value,
        );
        coffeeList.assignAll(data);
        filteredCoffeeList.assignAll(coffeeList);
        coffeeCount.value = coffeeList.length; // 👈 update count for category
      }
    } catch (e, st) {
      print("❌ fetchCoffees failed: $e");
      coffeeList.clear();
      coffeeCount.value = 0;
    } finally {
      isLoading(false);
    }
  }

  void setSelectedCategory(String category, String aid) {
    selectedCategory.value = category;
    fetchCoffees(aid);
  }
}
