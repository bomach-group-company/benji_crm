import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../services/api_url.dart';
import '../services/helper.dart';
import 'api_processor_controller.dart';

class PaymentController extends GetxController {
  static PaymentController get instance {
    return Get.find<PaymentController>();
  }

  var isLoad = false.obs;
  var responseObject = {}.obs;

  Future<void> getDeliveryFee(String packageId) async {
    isLoad.value = true;
    update();

    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}${Api.getDeliveryFee}$packageId/package'),
        headers: authHeader(),
      );

      consoleLog("${Api.baseUrl}${Api.getDeliveryFee}$packageId/package");
      consoleLog('Status Code: ${response.statusCode}');
      consoleLog('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);
        responseObject.value = (decodedBody as Map);
        log(responseObject.value.toString());
      } else {
        throw Exception(
            'Failed to fetch data. Status code: ${response.statusCode}');
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (error) {
      consoleLog('Error in getDeliveryFee: $error');
      ApiProcessorController.errorSnack(
          'Error in getting the delivery fee.\n ERROR: $error');
    } finally {
      isLoad.value = false;
      update();
    }
  }
}
