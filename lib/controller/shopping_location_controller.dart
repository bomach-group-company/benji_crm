import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/model/shopping_location.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/helper.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ShoppingLocationController extends GetxController {
  static ShoppingLocationController get instance {
    return Get.find<ShoppingLocationController>();
  }

  var isLoadCountry = false.obs;
  var isLoadState = false.obs;
  var isLoadCity = false.obs;
  var country = <ShoppingLocationCountry>[].obs;
  var state = <ShoppingLocationState>[].obs;
  var city = <ShoppingLocationCity>[].obs;

  Future getShoppingLocationCountries() async {
    isLoadCountry.value = true;
    var url = "${Api.baseUrl}/country/listAllCountries";
    try {
      http.Response response =
          await http.get(Uri.parse(url), headers: authHeader());
      country.value = (jsonDecode(response.body) as List)
          .map((e) => ShoppingLocationCountry.fromJson(e))
          .toList();
      isLoadCountry.value = false;

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      // ApiProcessorController.errorSnack("An error occurred ERROR: $e");
    }
    isLoadCountry.value = false;
    update();
  }

  Future getShoppingLocationState(String country) async {
    isLoadState.value = true;
    var url = "${Api.baseUrl}/country/getCountryStates/$country";
    try {
      http.Response? response =
          await http.get(Uri.parse(url), headers: authHeader());
      log(response.body);
      state.value = (jsonDecode(response.body) as List)
          .map((e) => ShoppingLocationState.fromJson(e))
          .toList();
      isLoadState.value = false;

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      // ApiProcessorController.errorSnack("An error occurred ERROR: $e");
    }
    isLoadState.value = false;
    update();
  }

  Future getShoppingLocationCity(String state) async {
    isLoadCity.value = true;
    var url = "${Api.baseUrl}/country/getCountryStatesCites/$state";
    try {
      http.Response? response =
          await http.get(Uri.parse(url), headers: authHeader());
      city.value = (jsonDecode(response.body) as List)
          .map((e) => ShoppingLocationCity.fromJson(e))
          .toList();
      isLoadCity.value = false;

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      // ApiProcessorController.errorSnack("An error occurred ERROR: $e");
    }
    isLoadCity.value = false;
    update();
  }
}
