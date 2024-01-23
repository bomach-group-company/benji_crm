import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/package/item_category.dart';
import '../model/package/item_weight.dart';
import '../services/api_url.dart';
import '../services/helper.dart';
import 'api_processor_controller.dart';

class SendPackageController extends GetxController {
  static SendPackageController get instance {
    return Get.find<SendPackageController>();
  }

  var isLoad = false.obs;
  var packageCategory = <ItemCategory>[].obs;
  var packageWeight = <ItemWeight>[].obs;

  Future<void> getPackageCategory() async {
    isLoad.value = true;
    update();

    try {
      final response = await http.get(
        Uri.parse(
          '${Api.baseUrl}${Api.getPackageCategory}?start=0&end=20',
        ),
        headers: authHeader(),
      );

      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);

        if (decodedBody is Map<String, dynamic> &&
            decodedBody.containsKey('items')) {
          consoleLog(decodedBody.toString());

          final List<dynamic> items = decodedBody['items'];

          // Map the items to ItemCategory and update the observable list
          packageCategory.value =
              items.map((item) => ItemCategory.fromJson(item)).toList();
          isLoad.value = false;
          update();
        } else {
          throw Exception('Unexpected response format: $decodedBody');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (error) {
      consoleLog('Error in getPackageCategory: $error');
      ApiProcessorController.errorSnack(
        'Error in getting package category.\n ERROR: $error',
      );
    } finally {
      isLoad.value = false;
      update();
    }
  }

  Future<void> getPackageWeight() async {
    isLoad.value = true;
    update();

    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}${Api.getPackageWeight}?start=0&end=20'),
        headers: authHeader(),
      );

      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);

        if (decodedBody is Map<String, dynamic> &&
            decodedBody.containsKey('items')) {
          consoleLog(decodedBody.toString());

          final List<dynamic> items = decodedBody['items'];

          // Map the items to ItemWeight and update the observable list
          packageWeight.value =
              items.map((item) => ItemWeight.fromJson(item)).toList();
          isLoad.value = false;
          update();
        } else {
          throw Exception('Unexpected response format: $decodedBody');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (error) {
      consoleLog('Error in getPackageWeight: $error');
      ApiProcessorController.errorSnack(
          'Error in getting package weight.\n ERROR: $error');
    } finally {
      isLoad.value = false;
      update();
    }
  }
}
