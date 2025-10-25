import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../services/api_store_services.dart';


class StoreController extends GetxController {

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

}