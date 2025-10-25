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
      return false;
    }
  }

  Future<void> fetchCategories() async {
    try {
      final result = await ApiCategoryServices.getCategories();
      categories.assignAll(result);
    } catch (e) {
      categories.clear();
    }
  }

  Future<void> deleteCategories(String id) async {
    try {
      final result = await ApiCategoryServices.deleteCategory(id);
      await fetchCategories();
    } catch (e) {
      categories.clear();
    }
  }
}
