import 'package:get/get.dart';
import '../../model/category.dart';
import '../services/api_category_services.dart';

class CategoryController extends GetxController {
  final categories = <Category>[].obs;

  Future<bool> addCategory(String name) async {
    try {
      await ApiCategoryServices.addCategory(name);
      await fetchCategories();
      return true;
    } catch (e) {
      print("⚠️ Error adding category: $e");
      return false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final result = await ApiCategoryServices.getCategories();
      categories.assignAll(result);
    } catch (e) {
      print("⚠️ Error fetching categories: $e");
      categories.clear();
    }
  }

  Future<void> deleteCategories(String id) async {
    try {
      // 🔹 Optimistic update (instant removal)
      categories.removeWhere((cat) => cat.id.toString() == id);

      // 🔹 Send delete request to backend
      await ApiCategoryServices.deleteCategory(id);

      // 🔹 (Optional) Re-fetch to ensure sync with server
      await fetchCategories();
    } catch (e) {
      print("⚠️ Error deleting category: $e");
    }
  }
}
