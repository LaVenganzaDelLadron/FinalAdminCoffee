import 'package:get/get.dart';
import '../../model/store.dart';
import '../services/api_store_services.dart';


class StoreController extends GetxController {

  var filteredStoreList = <Store>[].obs;
  var storeList = <Store>[].obs;
  var isLoading = false.obs;
  var storeCount = 0.obs;


  Future<void> AddStore(
      String name,
      String address,
      String prep_time_minutes,
      String status,
      ) async {
    try {
      final result = await ApiStoreServices.addStore(
        name,
        address,
        prep_time_minutes,
        status,
      );

      if (result["store_id"] != null) {
        print("Store added successfully: ${result["store_id"]}");
      }else {
        print("Failed to add store: ${result["error"]}");

      }
    }catch(e, stack){
      print(e);
    }
  }

  Future<void> updateStore(
      String store_id,
      String name,
      String address,
      String prep_time_minutes,
      String status,
      ) async {
    try {
      final result = await ApiStoreServices.updateStore(
        store_id,
        name,
        address,
        prep_time_minutes,
        status,
      );

      print("☕ Coffee Updated: ${result["coffee_id"]}");
      await fetchAllStores(); // refresh list
      storeCount.value = storeList.length;
    } catch (e, stack) {
      print("🔥 [ERROR] UpdateCoffee failed: $e\n$stack");
    }
  }

  Future<void> fetchAllStores() async {
    try {
      isLoading(true);
      final result = await ApiStoreServices.getAllStores();

      final data = result["stores"] ?? [];

      if (data is List) {
        storeList.assignAll(
          data.map((e) => Store.fromJson(e as Map<String, dynamic>)).toList(),
        );
      }else {
        storeList.clear();
      }
    }catch(e, stack) {
      print("❌ Error fetching orders: $e\n$stack");
    }finally {
      isLoading(false);
    }
  }



}