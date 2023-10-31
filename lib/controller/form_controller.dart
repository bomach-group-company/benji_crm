// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FormController extends GetxController {
  static FormController get instance {
    return Get.find<FormController>();
  }

  var isLoad = false.obs;
  var status = 0.obs;
  var responseObject = {}.obs;

  Future postAuth(String url, Map data, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.post(
      Uri.parse(url),
      headers: authHeader(),
      body: data,
    );
    status.value = response.statusCode;
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    responseObject.value = jsonDecode(response.body) as Map;
    update([tag]);
  }

  Future postNoAuth(String url, Map data, String tag,
      [String errorMsg = "Error occurred",
      String successMsg = "Submitted successfully"]) async {
    isLoad.value = true;
    update([tag]);
    final response = await http.post(
      Uri.parse(url),
      body: data,
    );
    status.value = response.statusCode;
    if (response.statusCode != 200) {
      ApiProcessorController.errorSnack(errorMsg);
      isLoad.value = false;
      update([tag]);
      return;
    }

    ApiProcessorController.successSnack(successMsg);
    isLoad.value = false;
    responseObject.value = jsonDecode(response.body) as Map;
    update([tag]);
  }
}
