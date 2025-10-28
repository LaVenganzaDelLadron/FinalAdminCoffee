import 'package:get/get.dart';
import '../../model/store.dart';
import '../services/api_store_services.dart';


class StoreController extends GetxController {

  var storeList = <Store>[].obs;
  var isLoading = false.obs;


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