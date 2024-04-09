// ignore_for_file: unused_element, unused_local_variable, empty_catches

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/create_vendor_model.dart';
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

  refreshData() {
    vendorMyList.value = [];
    thirdPartyVendorList.value = [];

    // vendor pagination
    loadNumVendor.value = 10;
    loadedAllVendor.value = false;

    // my vendor pagination
    loadNumMyVendor.value = 10;
    loadedAllMyVendor.value = false;
    isLoadMoreMyVendor.value = false;
    getMyVendors();
    getThirdPartyVendors();
  }

  Future<void> scrollListenerVendor(scrollController) async {
    if (VendorController.instance.loadedAllVendor.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      log("Gotten to the end");

      VendorController.instance.isLoadMoreVendor.value = true;
      update();
      await VendorController.instance.getMyVendors();
    }
  }

  Future<void> scrollListenerThirdPartyVendor(scrollController) async {
    if (VendorController.instance.loadedAllMyVendor.value) {
      return;
    }
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      log("Gotten to the end");
      VendorController.instance.isLoadMoreMyVendor.value = true;
      update();
      await VendorController.instance.getThirdPartyVendors();
    }
  }

  Future getMyVendors() async {
    isLoad.value = true;
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
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      allMyVendorList = jsonDecode(responseData)['total'];

      var data = (jsonDecode(responseData ?? '{}')['items'] as List)
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

  Future getThirdPartyVendors() async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.thirdPartyMyVendorList}?agent_id=$id&start=${loadNumMyVendor.value - 10}&end=${loadNumMyVendor.value}";
    loadNumMyVendor.value += 10;
    log(url);

    token = UserController.instance.user.value.token;
    List<MyVendorModel> data = [];

    try {
      http.Response? response = await HandleData.getApi(url, token);

      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      allMyThirdPartyVendorList = jsonDecode(responseData)['total'];

      var data = (jsonDecode(responseData ?? '{}')['items'] as List);

      var vendors = data.map((item) {
        var vendorData = item['vendor'] ?? {};
        return ThirdPartyVendorModel.fromJson(vendorData);
      }).toList();

      thirdPartyVendorList.value += vendors;
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

  Future createVendor(SendCreateModel data, bool classify) async {
    isLoadCreate.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    update();
    var url = Api.baseUrl + Api.createVendor + id;
    token = UserController.instance.user.value.token;
    log(url);
    log(token);
    log("Got here!");

    try {
      http.StreamedResponse? response =
          await HandleData.streamAddVendor(url, token, data, classify);

      // if (kDebugMode) {
      //   final res = await http.Response.fromStream(response!);
      //   print("This is the response body: ${jsonDecode(res.body)}");
      //   print("This is the status code: ${response.statusCode.toString()}");
      // }

      if (response!.statusCode == 200) {
        statusCode.value == response.statusCode;
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(
          "You have successfully added a vendor",
        );

        log("Got here!!!!");
        isLoadCreate.value = false;
        refreshData();
        Get.close(1);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(
          "An unexpected error occurred. Please try again later",
        );
        isLoadCreate.value = false;
      }
      isLoadCreate.value = false;
      log("We Got here!!!!!");

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack("An unexpected error occurred.\nERROR");
      log("An error occurred. ERROR: $e");
    }
    isLoadCreate.value = false;
    update();
  }

  Future createThirdPartyVendor(SendCreateModel data, bool classify) async {
    isLoadCreate.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    update();
    var url = Api.baseUrl + Api.createVendor + id;
    token = UserController.instance.user.value.token;

    log(url);

    try {
      http.StreamedResponse? response =
          await HandleData.streamAddThirdPartyVendor(
              url, token, data, classify);

      log(response!.statusCode.toString());
      final res = await http.Response.fromStream(response);
      var jsonData = jsonDecode(res.body);

      if (response.statusCode == 200) {
        statusCode.value == response.statusCode;

        // final res = await http.Response.fromStream(response);
        // var jsonData = jsonDecode(res.body);
        // log('${jsonData}heoollll');
        ApiProcessorController.successSnack(jsonData["message"]);
        isLoadCreate.value = false;
        refreshData();
        Get.close(1);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        isLoadCreate.value = false;
      }
      isLoadCreate.value = false;

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack("An unexpected error occurred.");
      log("An error occurred. ERROR: $e");
    }
    isLoadCreate.value = false;
    update();
  }
}
