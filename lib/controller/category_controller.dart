// ignore_for_file: unused_element, unused_local_variable, empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/business_type_model.dart';
import 'user_controller.dart';

class CategoryController extends GetxController {
  static CategoryController get instance {
    return Get.find<CategoryController>();
  }

  var isLoad = false.obs;
  var category = <BusinessType>[].obs;

  Future getCategory() async {
    isLoad.value = true;
    late String token;
    var url = "${Api.baseUrl}${Api.category}?start=0&end=100";
    token = UserController.instance.user.value.token;
    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData = ApiProcessorController.errorState(response);
      category.value = (jsonDecode(response!.body)['items'] as List)
          .map((e) => BusinessType.fromJson(e))
          .toList();
      consoleLog(response.body);
      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack("An error occurred ERROR: $e");
      debugPrint(e.toString());
    }
    isLoad.value = false;
    update();
  }
}
