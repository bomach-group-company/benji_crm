// ignore_for_file: unused_element, unused_local_variable, empty_catches

import 'dart:convert';
import 'dart:developer';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/third_party_vendor_model.dart';
import 'user_controller.dart';

class VendorController extends GetxController {
  static VendorController get instance {
    return Get.find<VendorController>();
  }

  bool? isFirst;
  VendorController({this.isFirst});
  var isLoad = false.obs;
  var isLoadCreate = false.obs;
  var statusCode = 0.obs;
  var vendorMyList = <MyVendorModel>[].obs;
  var thirdPartyVendorList = <ThirdPartyVendorModel>[].obs;

  var allMyVendorList = 0;
  var allMyThirdPartyVendorList = 0;

  // vendor pagination
  var loadNumVendor = 10.obs;
  var loadedAllVendor = false.obs;
  var isLoadMoreVendor = false.obs;

  // my vendor pagination
  var loadNumMyVendor = 10.obs;
  var loadedAllMyVendor = false.obs;
  var isLoadMoreMyVendor = false.obs;

  refreshData() async {
    vendorMyList.value = [];
    thirdPartyVendorList.value = [];

    // vendor pagination
    loadNumVendor.value = 10;
    loadedAllVendor.value = false;
    isLoadMoreVendor.value = false;

    // my vendor pagination
    loadNumMyVendor.value = 10;
    loadedAllMyVendor.value = false;
    isLoadMoreMyVendor.value = false;
    await getMyVendors();
    await getThirdPartyVendors();
  }

  Future<void> loadMoreVendor() async {
    if (loadedAllVendor.value || isLoadMoreVendor.value) {
      return;
    }

    isLoadMoreVendor.value = true;
    update();
    await getMyVendors(notMore: false);
  }

  Future<void> loadMoreThirdPartyVendor() async {
    if (loadedAllMyVendor.value || isLoadMoreMyVendor.value) {
      return;
    }

    isLoadMoreMyVendor.value = true;
    update();
    await getThirdPartyVendors(notMore: false);
  }

  Future getMyVendors({bool notMore = true}) async {
    if (notMore) {
      isLoad.value = true;
    }
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.vendorMyList}?agent_id=$id&start=${loadNumVendor.value - 10}&end=${loadNumVendor.value}";
    loadNumVendor.value += 10;
    log(url);

    token = UserController.instance.user.value.token;
    List<MyVendorModel> data = [];

    try {
      http.Response? response = await HandleData.getApi(url, token);
      // log(response!.body);
      var responseData = await ApiProcessorController.errorState(response);

      allMyVendorList = jsonDecode(responseData)['total'];

      data = (jsonDecode(responseData ?? '{}')['items'] as List)
          .map((e) => MyVendorModel.fromJson(e))
          .toList();

      // data = (jsonDecode(response.body)["items"] as List)
      //     .map((e) => MyVendorModel.fromJson(e))
      //     .toList();
      vendorMyList.value += data;
    } catch (e) {
      log("An error occurred. ERROR: $e");

      ApiProcessorController.errorSnack(
        "An error occurred in fetching vendors.",
      );
    }
    loadedAllVendor.value = data.isEmpty;
    isLoadMoreVendor.value = false;

    isLoad.value = false;
    update();
  }

  Future getThirdPartyVendors({bool notMore = true}) async {
    if (notMore) {
      isLoad.value = true;
    }
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.thirdPartyMyVendorList}?agent_id=$id&start=${loadNumMyVendor.value - 10}&end=${loadNumMyVendor.value}";
    loadNumMyVendor.value += 10;
    log(url);

    token = UserController.instance.user.value.token;
    List<ThirdPartyVendorModel> data = [];

    try {
      http.Response? response = await HandleData.getApi(url, token);

      var responseData = await ApiProcessorController.errorState(response);

      allMyThirdPartyVendorList = jsonDecode(responseData)['total'];

      data = (jsonDecode(responseData ?? '{}')['items'] as List)
          .map((e) => ThirdPartyVendorModel.fromJson(e))
          .toList();

      thirdPartyVendorList.value += data;
    } catch (e) {
      log("An error occurred in fetching vendors. ERROR: $e");
      ApiProcessorController.errorSnack(
        "An error occurred in fetching vendors. Please try again later.",
      );
    }
    loadedAllMyVendor.value = data.isEmpty;
    isLoadMoreMyVendor.value = false;

    isLoad.value = false;
    update();
  }
}
