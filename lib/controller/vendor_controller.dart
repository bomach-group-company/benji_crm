// ignore_for_file: unused_element, unused_local_variable, empty_catches

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/model/business_order_model.dart';
import 'package:benji_aggregator/model/my_vendor_model.dart';
import 'package:benji_aggregator/model/product_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:flutter/foundation.dart';
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
  var vendorMyList = <MyVendorModel>[].obs;
  var thirdPartyVendorList = <ThirdPartyVendorModel>[].obs;
  var allMyVendorList = 0;
  var allMyThirdPartyVendorList = 0;
  // var businessType = <BusinessType>[].obs;
  var vendorProductList = <ProductModel>[].obs;
  var vendorOrderList = <BusinessOrderModel>[].obs;

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

  // Future<void> scrollListenerVendor(scrollController) async {
  //   if (VendorController.instance.loadedAllVendor.value) {
  //     return;
  //   }

  //   if (scrollController.offset >= scrollController.position.maxScrollExtent &&
  //       !scrollController.position.outOfRange) {
  //     VendorController.instance.isLoadMoreVendor.value = true;
  //     update();
  //     await VendorController.instance.getVendors();
  //   }
  // }

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
      await VendorController.instance.getVendorProduct(vendorId, more: true);
    }
  }

  Future getMyVendors() async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.vendorMyList}?agent_id=$id&start=${loadNumMyVendor.value - 10}&end=${loadNumMyVendor.value}";
    loadNumMyVendor.value += 10;
    log(url);

    token = UserController.instance.user.value.token;
    List<MyVendorModel> data = [];

    try {
      http.Response? response = await HandleData.getApi(url, token);
      // log(response!.body);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      allMyVendorList = jsonDecode(responseData)['total'];
      log(allMyVendorList.toString());
      var data = (jsonDecode(responseData ?? '{}')['items'] as List)
          .map((e) => MyVendorModel.fromJson(e))
          .toList();

      // data = (jsonDecode(response.body)["items"] as List)
      //     .map((e) => MyVendorModel.fromJson(e))
      //     .toList();
      vendorMyList.value += data;
    } catch (e) {
      log("ERROR log: ${e.toString()}");
      ApiProcessorController.errorSnack(
        "An error occurred in fetching vendors. Please try again later.\n ERROR: $e",
      );
    }
    loadedAllMyVendor.value = data.isEmpty;
    isLoadMoreMyVendor.value = false;

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

      log("Thirdparty vendors: ${response!.body}");
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);

      allMyThirdPartyVendorList = jsonDecode(responseData)['total'];
      log(allMyThirdPartyVendorList.toString());
      var data = (jsonDecode(responseData ?? '{}')['items'] as List)
          .map((e) => ThirdPartyVendorModel.fromJson(e))
          .toList();

      // data = (jsonDecode(response.body)["items"] as List)
      //     .map((e) => MyVendorModel.fromJson(e))
      //     .toList();
      thirdPartyVendorList.value += data;
    } catch (e) {
      log("ERROR loggg: ${e.toString()}");
      ApiProcessorController.errorSnack(
        "An error occurred in fetching vendors. Please try again later.\n ERROR: $e",
      );
    }
    loadedAllMyVendor.value = data.isEmpty;
    isLoadMoreMyVendor.value = false;

    isLoad.value = false;
    update();
  }

  Future getVendorProduct(
    id, {
    bool more = false,
  }) async {
    if (!more) {
      vendorProductList.value = [];
      loadedAllProduct.value = false;
      loadNumProduct.value = 10;
    }
    if (loadedAllProduct.value) {
      return;
    }

    isLoadMoreProduct.value = true;

    isLoad.value = true;

    var url =
        "${Api.baseUrl}${Api.getVendorProducts}$id?start=${loadNumProduct.value - 10}&end=${loadNumProduct.value}";
    loadNumProduct.value += 10;
    String token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);
    var responseData = await ApiProcessorController.errorState(response);
    if (responseData == null) {
      isLoad.value = false;
      isLoadMoreProduct.value = false;

      update();
      return;
    }

    List<ProductModel> data = [];
    try {
      data = (jsonDecode(response!.body)['items'] as List)
          .map((e) => ProductModel.fromJson(e))
          .toList();
      vendorProductList.value = data;
    } catch (e) {
      debugPrint(e.toString());
    }
    loadedAllProduct.value = data.isEmpty && more;
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
              .map((e) => BusinessOrderModel.fromJson(e));
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
    log(url);
    log(token);
    log("Got here!");

    try {
      log("Got here!!");
      http.StreamedResponse? response =
          await HandleData.streamAddVendor(url, token, data, classify);

      log("Got here!!!");
      // if (kDebugMode) {
      //   final res = await http.Response.fromStream(response!);
      //   print("This is the response body: ${jsonDecode(res.body)}");
      //   print("This is the status code: ${response.statusCode.toString()}");
      // }
      if (response!.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        ApiProcessorController.successSnack(
          "You have successfully added a vendor",
        );

        log("Got here!!!!");
        isLoadCreate.value = false;
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
      ApiProcessorController.errorSnack(
        "An unexpected error occurred.\nERROR $e",
      );
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
      log('${jsonData}heoollll');
      if (response.statusCode == 200) {
        // final res = await http.Response.fromStream(response);
        // var jsonData = jsonDecode(res.body);
        // log('${jsonData}heoollll');
        ApiProcessorController.successSnack(jsonData["message"]);
        isLoadCreate.value = false;
        Get.close(1);
      } else {
        final res = await http.Response.fromStream(response);
        var jsonData = jsonDecode(res.body);
        isLoadCreate.value = false;
      }
      isLoadCreate.value = false;
      log("Got here, 2nd response: $response");

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack("An error occurred. ERROR: $e");
      log("An error occurred. ERROR: $e");
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
    log(url);

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
        log("res: $res");
      }
      isLoadCreate.value = false;

      update();
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      ApiProcessorController.errorSnack("An error occurred. \nERROR: $e");
      log("An error occured. ERROR: $e");
    }
    isLoadCreate.value = false;
    update();
  }
}
