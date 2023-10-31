// ignore_for_file: empty_catches

import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/order.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController {
  static OrderController get instance {
    return Get.find<OrderController>();
  }

  bool? isFirst;
  OrderController({this.isFirst});
  var isLoad = false.obs;
  var orderList = <Order>[].obs;

  Future getOrders([String? end]) async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    var url = "${Api.baseUrl}${Api.orderList}$id/?start=1&end=${end ?? 100}";
    token = UserController.instance.user.value.token;
    http.Response? response = await HandleData.getApi(url, token);
    var responseData =
        await ApiProcessorController.errorState(response, isFirst ?? true);
    if (responseData == null) {
      return;
    }

    try {
      orderList.value = (jsonDecode(responseData)['items'] as List)
          .map((e) => Order.fromJson(e))
          .toList();
    } catch (e) {
      consoleLog(e.toString());
    }

    isLoad.value = false;
    update();
  }
}
