import 'dart:io';
import 'package:get/get.dart';
import '../../model/order.dart';
import '../../model/top_selling.dart';
import '../services/api_order_services.dart';


class OrderController extends GetxController {
  var orderList = <Order>[].obs;
  var topSellingList = <TopSelling>[].obs;
  var isLoading = false.obs;


  Future<int> fetchOrderCount() async {
    try {
      final result = await ApiOrderServices.orderCount();

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

  Future<void> fetchAllOrders() async {
    try {
      isLoading(true);
      final result = await ApiOrderServices.getAllOrders();

      final data = result["data"]?["orders"] ?? result["orders"];

      if (data is List) {
        orderList.assignAll(
          data.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList(),
        );
      } else {
        orderList.clear();
      }
    } catch (e, stack) {
      print("❌ Error fetching orders: $e\n$stack");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTopSellingOrder() async {
    try {
      isLoading(true);
      final result = await ApiOrderServices.getTopSelling();
      final data = result["data"]?["top_selling"] ?? result["top_selling"];

      if (data is List) {
        topSellingList.assignAll(
          data
              .map((e) => TopSelling.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      } else {
        topSellingList.clear();
      }
    } catch (e, stack) {
      print("❌ Error fetching top-selling orders: $e\n$stack");
    } finally {
      isLoading(false);
    }
  }
}


