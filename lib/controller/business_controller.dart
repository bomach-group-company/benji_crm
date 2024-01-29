import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/business_model.dart';
import '../services/api_url.dart';
import 'api_processor_controller.dart';
import 'user_controller.dart';

class BusinessController extends GetxController {
  static BusinessController get instance {
    return Get.find<BusinessController>();
  }

  bool? isFirst;
  BusinessController({this.isFirst});
  var isLoad = false.obs;
  var listOfBusinesses = <BusinessModel>[].obs;
  var totalNumberOfBusiness = <BusinessModel>[].obs;
  // vendor pagination
  var loadNumBusinesses = 10.obs;
  var loadedAllBusinesses = false.obs;
  var isLoadMoreBusinesses = false.obs;

  Future<void> scrollListenerMyVendor(
      scrollController, String vendorId, agentId) async {
    if (BusinessController.instance.loadedAllBusinesses.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      BusinessController.instance.isLoadMoreBusinesses.value = true;
      update();
      await BusinessController.instance.getBusinesses(vendorId, agentId);
    }
  }

  Future getBusinesses(String vendorId, agentId) async {
    isLoad.value = true;

    late String token;
    token = UserController.instance.user.value.token;

    var url = "${Api.baseUrl}${Api.getVendorBusinesses}$vendorId/$agentId";
    log(url);
    loadNumBusinesses.value += 10;

    List<BusinessModel> data = [];
    try {
      http.Response? response = await HandleData.getApi(url, token);

      log(response!.body);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      data = (jsonDecode(responseData) as List)
          .map((e) => BusinessModel.fromJson(e))
          .toList();
      log("Got here!");

      listOfBusinesses.value = data;
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (e) {
      consoleLog("ERROR log: ${e.toString()}");
      ApiProcessorController.errorSnack(
        "An error occurred in fetching the businesses. Please try again later.\n ERROR: $e",
      );
    }
    loadedAllBusinesses.value = data.isEmpty;
    isLoadMoreBusinesses.value = false;

    isLoad.value = false;
    update();
  }

  Future getTotalNumberOfBusinesses(String vendorId, agentId) async {
    isLoad.value = true;

    late String token;
    token = UserController.instance.user.value.token;

    var url = "${Api.baseUrl}${Api.getVendorBusinesses}$vendorId/$agentId";

    loadNumBusinesses.value += 10;

    List<BusinessModel> data = [];
    try {
      http.Response? response = await HandleData.getApi(url, token);

      log(response!.body);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      data = (jsonDecode(responseData) as List)
          .map((e) => BusinessModel.fromJson(e))
          .toList();
      log("Got all businesses here!");

      totalNumberOfBusiness.value = data;
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet.");
    } catch (e) {
      consoleLog("ERROR log: ${e.toString()}");
      ApiProcessorController.errorSnack(
        "An error occurred in fetching the businesses. Please try again later.\n ERROR: $e",
      );
    }
    loadedAllBusinesses.value = data.isEmpty;
    isLoadMoreBusinesses.value = false;

    isLoad.value = false;
    update();
  }
}
