// ignore_for_file: unused_element, unused_local_variable, empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/model/order.dart';
import 'package:benji_aggregator/model/product_model.dart';
import 'package:benji_aggregator/model/vendor_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/create_vendor_model.dart';
import 'user_controller.dart';

class VendorController extends GetxController {
  static VendorController get instance {
    return Get.find<VendorController>();
  }

  bool? isFirst;
  VendorController({this.isFirst});
  var isLoad = false.obs;
  var isLoadCreate = false.obs;
  var vendorList = <VendorModel>[].obs;
  var vendorMyList = <MyVendorModel>[].obs;
  // var businessType = <BusinessType>[].obs;
  var vendorProductList = <Product>[].obs;
  var vendorOrderList = <Order>[].obs;

  // vendor pagination
  var loadNumVendor = 10.obs;
  var loadedAllVendor = false.obs;
  var isLoadMoreVendor = false.obs;

  // my vendor pagination
  var loadNumMyVendor = 10.obs;
  var loadedAllMyVendor = false.obs;
  var isLoadMoreMyVendor = false.obs;

  // product pagination
  var loadedAllProduct = false.obs;
  var isLoadMoreProduct = false.obs;
  var loadNumProduct = 10.obs;

  Future<void> scrollListenerVendor(scrollController) async {
    if (VendorController.instance.loadedAllVendor.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      VendorController.instance.isLoadMoreVendor.value = true;
      update();
      await VendorController.instance.getVendors();
    }
  }

  Future<void> scrollListenerMyVendor(scrollController) async {
    if (VendorController.instance.loadedAllMyVendor.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      VendorController.instance.isLoadMoreMyVendor.value = true;
      update();
      await VendorController.instance.getMyVendors();
    }
  }

  Future<void> scrollListenerProduct(scrollController, vendorId) async {
    if (VendorController.instance.loadedAllProduct.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      VendorController.instance.isLoadMoreProduct.value = true;
      update();
      await VendorController.instance.getVendorProduct(vendorId);
    }
  }

  Future getVendors() async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.vendorList}?agent_id=$id&start=${loadNumVendor.value - 10}&end=${loadNumVendor.value}";
    loadNumVendor.value += 10;

    token = UserController.instance.user.value.token;
    List<VendorModel> data = [];
    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      data = (jsonDecode(response!.body)['items'] as List)
          .map((e) => VendorModel.fromJson(e))
          .toList();
      vendorList.value += data;
    } catch (e) {}
    isLoad.value = false;
    isLoadMoreVendor.value = false;
    loadedAllVendor.value = data.isEmpty;

    update();
  }

  Future getMyVendors() async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.vendorMyList}?agent_id=$id&start=${loadNumMyVendor.value - 10}&end=${loadNumMyVendor.value}";
    loadNumMyVendor.value += 10;

    token = UserController.instance.user.value.token;
    List<MyVendorModel> data = [];

    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      data = (jsonDecode(response!.body)['items'] as List)
          .map((e) => MyVendorModel.fromJson(e))
          .toList();
      vendorMyList.value += data;
    } catch (e) {}
    loadedAllMyVendor.value = data.isEmpty;
    isLoadMoreMyVendor.value = false;

    isLoad.value = false;
    update();
  }

  Future getVendorProduct(
    id, {
    bool first = false,
  }) async {
    if (first) {
      loadNumProduct.value = 10;
    }
    if (loadedAllProduct.value) {
      return;
    }
    if (!first) {
      isLoadMoreProduct.value = true;
    }
    isLoad.value = true;

    var url =
        "${Api.baseUrl}${Api.getVendorProducts}$id?start=${loadNumProduct.value - 10}&end=${loadNumProduct.value}";
    loadNumProduct.value += 10;
    String token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);
    var responseData = await ApiProcessorController.errorState(response);
    if (responseData == null) {
      isLoad.value = false;
      if (!first) {
        isLoadMoreProduct.value = false;
      }

      update();
      return;
    }
    List<Product> data = [];
    try {
      data = (jsonDecode(response!.body)['items'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
      vendorProductList.value += data;
    } catch (e) {
      debugPrint(e.toString());
    }
    loadedAllProduct.value = data.isEmpty;
    isLoad.value = false;
    isLoadMoreProduct.value = false;

    update();
  }

  Future listVendorOrder(id, [int? end]) async {
    Future filterProductBySubCat(vendorId, subCatId) async {
      isLoad.value = true;
      late String token;
      update();
      var url =
          "${Api.baseUrl}${Api.listVendorOrders}$id?start=1&end=${end ?? 1}";
      token = UserController.instance.user.value.token;

      try {
        http.Response? response = await HandleData.getApi(url, token);
        var responseData = await ApiProcessorController.errorState(response);
        if (responseData == null) {
          return;
        }
        try {
          var save = (jsonDecode(responseData)['items'] as List)
              .map((e) => Order.fromJson(e));
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
        }
        update();
      } catch (e) {}
      isLoad.value = false;
      update();
    }
  }

  Future createVendor(SendCreateModel data, bool classify) async {
    isLoadCreate.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    update();
    var url = Api.baseUrl + Api.createVendor + id;
    token = UserController.instance.user.value.token;

    try {
      http.StreamedResponse? response =
          await HandleData.streamAddVendor(url, token, data, classify);
      if (response == null) {
        isLoadCreate.value = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(jsonData);
        isLoadCreate.value = false;
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
      ApiProcessorController.errorSnack("An error occurred. \nERROR: $e");
    }
    isLoadCreate.value = false;
    update();
  }

  Future createThirdPartyVendor(SendCreateModel data) async {
    isLoadCreate.value = true;
    late String token;
    String agentId = UserController.instance.user.value.id.toString();
    update();
    var url = Api.baseUrl + Api.createThirdPartyVendor + agentId;
    token = UserController.instance.user.value.token;

    consoleLog(url);

    try {
      http.StreamedResponse? response =
          await HandleData.streamAddThirdPartyVendor(url, token, data);
      if (response == null) {
        isLoadCreate.value = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(jsonData);
        isLoadCreate.value = false;
        Get.close(1);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        isLoadCreate.value = false;
      }
      isLoadCreate.value = false;
      consoleLog("Got here, 2nd response: $response");

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack("An error occurred. ERROR: $e");
      consoleLog("An error occurred. ERROR: $e");
    }
    isLoadCreate.value = false;
    update();
  }

  Future addToAVendor(SendCreateModel data, int vendorId) async {
    isLoadCreate.value = true;
    late String token;
    update();
    var url = "${Api.baseUrl}${Api.createVendorOtherBusiness}$vendorId";
    token = UserController.instance.user.value.token;
    consoleLog(url);

    try {
      http.StreamedResponse? response =
          await HandleData.streamAddToVendor(url, token, data);
      if (response == null) {
        isLoadCreate.value = false;
      } else if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(jsonData);
        isLoadCreate.value = false;
        Get.close(1);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        isLoadCreate.value = false;
        consoleLog("res: $res");
      }
      isLoadCreate.value = false;

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack("An error occurred. \nERROR: $e");
      consoleLog("An error occured. ERROR: $e");
    }
    isLoadCreate.value = false;
    update();
  }
}
