// ignore_for_file: unused_element, unused_local_variable, empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/model/vendor_list_model.dart';
import 'package:benji_aggregator/model/vendor_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/business_trype_model.dart';
import '../model/create_vendor_model.dart';
import '../model/vendor_orders_model.dart';
import '../model/vendor_product_model.dart';
import 'user_controller.dart';

class VendorController extends GetxController {
  static VendorController get instance {
    return Get.find<VendorController>();
  }

  bool? isFirst;
  VendorController({this.isFirst});
  var isLoad = false.obs;
  var isLoadCreate = false.obs;
  var vendorList = <VendorListModel>[].obs;
  var businessType = <BusinessType>[].obs;
  var vendorProductList = <Item>[].obs;
  var vendorOrderList = <DataItem>[].obs;
  var vendor = VendorModel().obs;

  @override
  void onInit() {
    runTask();

    super.onInit();
  }

  Future runTask() async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    //update();
    var url = "${Api.baseUrl}${Api.vendorList}?agent_id=$id";
    token = UserController.instance.getUserSync().token;
    consoleLog(token);
    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      var save = vendorListModelFromJson(responseData);
      vendorList.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future getSpecificVendor(id) async {
    late String token;
    isLoad.value = true;
    update();
    var url = Api.baseUrl + Api.getSpecificVendor + id.toString();
    token = UserController.instance.getUserSync().token;
    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = VendorModel.fromJson(responseData);
      vendor.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future listVendorProduct(id, [int? end]) async {
    isLoad.value = true;
    late String token;
    update();
    var url =
        "${Api.baseUrl}${Api.getVendorProducts}$id?start=1&end=${end ?? 1}";
    token = UserController.instance.getUserSync().token;

    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      if (responseData == null) {
        return;
      }
      try {
        var save = VendorProductListModel.fromJson(jsonDecode(responseData));
        vendorProductList.value = save.items!;
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

  Future listVendorOrder(id, [int? end]) async {
    Future filterProductBySubCat(vendorId, subCatId) async {
      isLoad.value = true;
      late String token;
      update();
      var url =
          "${Api.baseUrl}${Api.listVendorOrders}$id?start=1&end=${end ?? 1}";
      token = UserController.instance.getUserSync().token;

      try {
        http.Response? response = await HandleData.getApi(url, token);
        var responseData = await ApiProcessorController.errorState(response);
        if (responseData == null) {
          return;
        }
        try {
          var save = VendorOrderModel.fromJson(jsonDecode(responseData));
          vendorOrderList.value = save.items!;
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

    Future getBusinessTypes() async {
      isLoad.value = true;
      late String token;

      var url = Api.baseUrl + Api.businessType;
      token = UserController.instance.getUserSync().token;

      try {
        http.Response? response = await HandleData.getApi(url, token);
        try {
          var responseData = await ApiProcessorController.errorState(
              response, isFirst ?? true);
          if (responseData == null) {
            return;
          }
          var save = businessTypeFromJson(responseData);
          businessType.value = save;
        } catch (e) {
          consoleLog('from $e');
        }
        update();
      } catch (e) {}
      isLoad.value = false;
      update();
    }

    Future createVendor(SendCreateModel data, bool classify) async {
      isLoadCreate.value = true;
      late String token;
      String id = UserController.instance.user.value.id.toString();
      update();
      var url = Api.baseUrl + Api.createVendor + id;
      token = UserController.instance.getUserSync().token;

      try {
        http.StreamedResponse? response =
            await HandleData.streamAddVCendor(url, token, data, classify);
        if (response == null) {
          isLoadCreate.value = false;
        } else if (response.statusCode == 200) {
          final res = await http.Response.fromStream(response);
          var jsonData = jsonDecode(res.body);
          ApiProcessorController.successSnack(jsonData);
          consoleLog(jsonData);
          isLoadCreate.value = false;
          Get.close(1);
        } else {
          final res = await http.Response.fromStream(response);
          var jsonData = jsonDecode(res.body);
          consoleLog(res.body.toString());
          isLoadCreate.value = false;
        }
        isLoadCreate.value = false;

        update();
      } catch (e) {}
      isLoadCreate.value = false;
      update();
    }
  }
}
