import 'package:get/get.dart';
import '../services/api_money_services.dart';

class MoneyController extends GetxController {
  static final MoneyController instance = Get.put(MoneyController());


  Future<double> fetchTotalRevenue() async {
    try {
      final result = await ApiMoneyServices.getMoneyData();

      if (result != null && result.containsKey("total_revenue")) {
        return double.tryParse(result["total_revenue"].toString()) ?? 0.0;
      }
    } catch (e) {
      print("Error fetching total revenue: $e");
    }
    return 0.0;
  }

  Future<double> fetchPendingPayments() async {
    try {
      final result = await ApiMoneyServices.getPendingMoneyData();

      if (result != null && result.containsKey("pending_revenue")) {
        return double.tryParse(result["pending_revenue"].toString()) ?? 0.0;
      }
    } catch (e) {
      print("Error fetching pending payments: $e");
    }
    return 0.0;
  }

}
