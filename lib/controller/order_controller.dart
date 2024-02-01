// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:benji_aggregator/controller/api_processor_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/business_order_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../app/business_orders/orders.dart';
import '../app/third_party_business_orders/third_party_orders.dart';
import '../services/helper.dart';

class OrderController extends GetxController {
  static OrderController get instance {
    return Get.find<OrderController>();
  }

  bool? isFirst;
  OrderController({this.isFirst});
  var isLoad = false.obs;
  var orderList = <BusinessOrderModel>[].obs;

  var loadedAll = false.obs;
  var isLoadMore = false.obs;
  var loadNum = 10.obs;
  var total = 0.obs;
  var status = StatusType.pending.obs;
  var thirdpartyorderstatus = ThirdPartyBusinessStatusType.pending.obs;

  resetOrders() async {
    orderList.value = <BusinessOrderModel>[];
    loadedAll.value = false;
    isLoadMore.value = false;
    loadNum.value = 10;
    total.value = 0;
    status.value = StatusType.pending;

    setStatus();
  }

  resetThirdPartyOrders() async {
    orderList.value = <BusinessOrderModel>[];
    loadedAll.value = false;
    isLoadMore.value = false;
    loadNum.value = 10;
    total.value = 0;

    thirdpartyorderstatus.value = ThirdPartyBusinessStatusType.pending;
    setThirdPartyStatus();
  }

  Future<void> scrollListener(scrollController) async {
    if (OrderController.instance.loadedAll.value) {
      return;
    }

    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      OrderController.instance.isLoadMore.value = true;
      update();
      await OrderController.instance.getOrders();
    }
  }

  setStatus([StatusType newStatus = StatusType.pending]) async {
    status.value = newStatus;
    // if (newStatus == StatusType.pending) {
    //   orderList.value = vendorPendingOrders;
    // } else if (newStatus == StatusType.dispatched) {
    //   orderList.value = vendorDispatchedOrders;
    // } else if (newStatus == StatusType.delivered) {
    //   orderList.value = vendorDeliveredOrders;
    // } else {
    // }
    orderList.value = [];
    loadNum.value = 10;
    loadedAll.value = false;
    update();
    await getOrdersByStatus();
  }

  setThirdPartyStatus(
      [ThirdPartyBusinessStatusType newStatus =
          ThirdPartyBusinessStatusType.pending]) async {
    thirdpartyorderstatus.value = newStatus;
    // if (newStatus == StatusType.pending) {
    //   orderList.value = vendorPendingOrders;
    // } else if (newStatus == StatusType.dispatched) {
    //   orderList.value = vendorDispatchedOrders;
    // } else if (newStatus == StatusType.delivered) {
    //   orderList.value = vendorDeliveredOrders;
    // } else {
    // }
    orderList.value = [];
    loadNum.value = 10;
    loadedAll.value = false;
    update();
    await getOrdersByStatus();
  }

  Future getOrdersByStatus() async {
    if (loadedAll.value) {
      return;
    }
    isLoad.value = true;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.vendorsOrderList}$id/listMyOrdersByStatus?start=${loadNum.value - 10}&end=${loadNum.value}&status=${statusTypeConverter(status.value)}";

    consoleLog(url);
    loadNum.value += 10;
    String token = UserController.instance.user.value.token;
    var response = await HandleData.getApi(url, token);

    var responseData = await ApiProcessorController.errorState(response);
    if (responseData == null) {
      isLoad.value = false;
      loadedAll.value = true;
      isLoadMore.value = false;
      update();
      return;
    }
    List<BusinessOrderModel> data = [];
    try {
      var decodedResponse = jsonDecode(responseData);
      data = (decodedResponse as List)
          .map((e) => BusinessOrderModel.fromJson(e))
          .toList();

      orderList.value += data;
      // if (status.value == StatusType.pending) {
      //   vendorPendingOrders.value += data;
      // } else if (status.value == StatusType.dispatched) {
      //   vendorDispatchedOrders.value += data;
      // } else if (status.value == StatusType.delivered) {
      //   vendorDeliveredOrders.value += data;
      // }
    } on SocketException {
      ApiProcessorController.errorSnack("Please connect to the internet");
    } catch (e) {
      consoleLog(e.toString());
    }
    loadedAll.value = data.isEmpty;
    isLoad.value = false;
    isLoadMore.value = false;
    update();
  }

  Future getOrders({
    bool first = false,
  }) async {
    if (first) {
      loadNum.value = 10;
    }
    if (loadedAll.value) {
      return;
    }
    if (!first) {
      isLoadMore.value = true;
    }
    isLoad.value = true;
    if (loadedAll.value) {
      return;
    }
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url =
        "${Api.baseUrl}${Api.orderList}$id/?start=${loadNum.value - 10}&end=${loadNum.value}";
    loadNum.value += 10;
    token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);
    var responseData =
        await ApiProcessorController.errorState(response, isFirst ?? true);
    if (responseData == null) {
      if (!first) {
        isLoadMore.value = false;
      }
      isLoad.value = false;
      return;
    }
    List<BusinessOrderModel> data = [];
    try {
      data = (jsonDecode(responseData)['items'] as List)
          .map((e) => BusinessOrderModel.fromJson(e))
          .toList();
      orderList.value += data;
    } catch (e) {
      consoleLog(e.toString());
    }
    loadedAll.value = data.isEmpty;
    isLoad.value = false;
    isLoadMore.value = false;
    update();
  }
}
