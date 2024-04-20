// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/package/delivery_item.dart';
import 'package:benji_aggregator/model/package/item_category.dart';
import 'package:benji_aggregator/model/package/item_weight.dart';
import 'package:benji_aggregator/model/user_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyPackageController extends GetxController {
  static MyPackageController get instance {
    return Get.find<MyPackageController>();
  }

  var isLoadDelivered = false.obs;
  var isLoadDispatched = false.obs;
  var isLoadPending = false.obs;
  var isLoad = false.obs;
  var packageCategory = <ItemCategory>[].obs;
  var packageWeight = <ItemWeight>[].obs;
  var pendingPackages = <DeliveryItem>[].obs;
  var dispatchedPackages = <DeliveryItem>[].obs;
  var deliveredPackages = <DeliveryItem>[].obs;

  Future getDeliveryItemsByPending() async {
    isLoadPending.value = true;
    UserModel? user = UserController.instance.user.value;
    final response = await http.get(
        Uri.parse(
            '$baseURL/sendPackage/gettemPackageByClientId/${user.id}/pending'),
        headers: authHeader());
    if (response.statusCode == 200) {
      pendingPackages.value = (jsonDecode(response.body) as List)
          .map((item) => DeliveryItem.fromJson(item))
          .toList();
    }

    isLoadPending.value = false;
    update();
  }

  Future getDeliveryItemsByDispatched() async {
    isLoadDelivered.value = true;
    update();
    UserModel? user = UserController.instance.user.value;
    final response = await http.get(
        Uri.parse(
            '$baseURL/sendPackage/gettemPackageByClientId/${user.id}/dispatched'),
        headers: authHeader());
    if (response.statusCode == 200) {
      dispatchedPackages.value = (jsonDecode(response.body) as List)
          .map((item) => DeliveryItem.fromJson(item))
          .toList();
    }
    log('deliveredPackages.value ${dispatchedPackages.value}');
    isLoadDelivered.value = false;
    update();
  }

  Future getDeliveryItemsByDelivered() async {
    log('got to the getDeliveryItemsByDelivered');

    isLoadDelivered.value = true;
    update();
    UserModel? user = UserController.instance.user.value;
    final response = await http.get(
        Uri.parse(
            '$baseURL/sendPackage/gettemPackageByClientId/${user.id}/completed'),
        headers: authHeader());
    if (response.statusCode == 200) {
      deliveredPackages.value = (jsonDecode(response.body) as List)
          .map((item) => DeliveryItem.fromJson(item))
          .toList();
    }
    isLoadDelivered.value = false;
    update();
  }

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
      print(response.body);
      if (response.statusCode == 200) {
        final dynamic decodedBody = jsonDecode(response.body);

        if (decodedBody is Map<String, dynamic> &&
            decodedBody.containsKey('items')) {
          log(decodedBody.toString());

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
      log('Error in getPackageCategory: $error');
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
          log(decodedBody.toString());

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
      log('Error in getPackageWeight: $error');
      ApiProcessorController.errorSnack(
          'Error in getting package weight.\n ERROR: $error');
    } finally {
      isLoad.value = false;
      update();
    }
  }
}
