// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:developer';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/order_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../model/rider_model.dart';

class RiderController extends GetxController {
  static RiderController get instance {
    return Get.find<RiderController>();
  }

  bool? isFirst;
  RiderController({this.isFirst});

  var moreNum = 10.obs;
  var loadedAll = false.obs;
  var isLoad = false.obs;
  var isLoadMore = false.obs;
  var isLoadAssign = false.obs;
  var riderList = <RiderItem>[].obs;
  var rider = RiderItem.fromJson(null).obs;
  var total = 0.obs;

  Future getRiders() async {
    late String token;
    isLoad.value = true;
    update();
    var url = "${Api.baseUrl}${Api.riderList}?start=0&end=10";
    token = UserController.instance.user.value.token;
    try {
      http.Response? response = await HandleData.getApi(url, token);

      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      log(responseData);
      if (responseData == null) {
        return;
      }

      total.value = jsonDecode(responseData)['total'];
      riderList.value = (jsonDecode(responseData)['items'] as List)
          .map((e) => RiderItem.fromJson(e))
          .toList();
      update();
    } catch (e) {
      consoleLog("$e");
    }
    isLoad.value = false;
    moreNum.value += 10;
    loadedAll.value = false;
    update();
  }

  Future loadMore() async {
    late String token;
    isLoadMore.value = true;
    var url =
        "${Api.baseUrl}${Api.riderList}?start=${moreNum.value - 10}&end=${moreNum.value}";
    token = UserController.instance.user.value.token;
    print('$url $moreNum chai');
    moreNum.value += 10;
    try {
      http.Response? response = await HandleData.getApi(url, token);

      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      log(responseData);
      if (responseData == null) {
        update();
        return;
      }
      List<RiderItem> val = (jsonDecode(responseData)['items'] as List)
          .map((e) => RiderItem.fromJson(e))
          .toList();
      riderList.value += val;
      loadedAll.value = val.isEmpty;
      update();
    } catch (e) {
      consoleLog("$e");
    }
    isLoadMore.value = false;
    update();
  }

  emptyRiderList() {
    riderList.value = [];
    loadedAll.value = false;
    moreNum.value = 10;
    update();
  }

  Future getSpecificRider(id) async {
    late String token;
    isLoad.value = true;
    update();
    var url = Api.baseUrl + Api.getSpecificRider + id.toString();
    token = UserController.instance.user.value.token;
    try {
      http.Response? response = await HandleData.getApi(url, token);
      var responseData = await ApiProcessorController.errorState(response);
      var save = RiderItem.fromJson(responseData);
      rider.value = save;
      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }

  Future assignRiderTask(agentId, riderId, orderId) async {
    late String token;
    isLoadAssign.value = true;
    update();
    var url =
        "${Api.baseUrl}${Api.assignRiderTask}?agent_id=$agentId&rider_id=$riderId";
    var order = {
      "orders": ["$orderId"]
    };
    consoleLog(order.toString());
    var data = order;
    token = UserController.instance.user.value.token;
    try {
      http.Response? response = await HandleData.postApi(url, token, data);
      var responseData = await ApiProcessorController.errorState(response);
      if (responseData == null) {
        isLoadAssign.value = false;
      } else {
        OrderController.instance.getOrders();
        isLoadAssign.value = false;
        Get.close(3);
      }

      update();
    } catch (e) {}
    isLoadAssign.value = false;
    update();
  }
}
